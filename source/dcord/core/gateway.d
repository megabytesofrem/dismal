module dcord.core.gateway;

import std.stdio;
import std.format;
import std.typecons : Nullable;
import std.functional : toDelegate;
import std.conv;
import core.time : seconds;

// vibe
import vibe.core.core;
import vibe.inet.message;
import vibe.data.json;
import vibe.data.serialization;
import vibe.http.client;
import vibe.http.websockets;

import dcord.http.client;
import dcord.core.packets;
import dcord.models;
import dcord.core.opcodes;

/** https://discord.com/developers/docs/topics/gateway#get-gateway-bot */
struct HTTPGatewayResponse
{
    string url;
    int shards;
}

/**
 * Provides an interface for interacting with the Discord gateway API at a low level.
 * Use Client instead for client facing communication
 *
 * Bugs: Seems to warn about "leaking eventcore driver because there are active handles"
 * but seems to work fine for now, need to look into this though.
 */
class Gateway
{
    import dcord.client;
    import dcord.logging.logger : infoLog, warnLog, errorLog;
    import dcord.endpoints : Endpoints;

private
    string _webSocketUrl;
    int _heartbeatInterval;
    Client _client;
    WebSocket _ws;

    HTTPGatewayResponse connectBot(string token) {
        auto res = requestDiscord(HTTPMethod.GET, "/gateway/bot", (scope req) {
            req.headers.addField("Content-Type", "application/json");
            req.headers.addField("Authorization", "Bot " ~ token);
        });

        return deserializeJson!HTTPGatewayResponse(res.readJson());
    }

    void sendHeartbeat() {
        // Build the payload to send
        auto payload = HeartbeatPayload(GatewayOpcodes.heartbeat, OpHeartbeat(Nullable!int.init));
        this._ws.send(serializeToJsonString!HeartbeatPayload(payload));

        infoLog("sending heartbeat to discord gateway..");
    }

    void decodePacket(string json) {
        int opcode;
        Json jsonData;

        jsonData = parseJsonString(json);
        opcode = jsonData["op"].get!int;

        infoLog("op: %d, name: %s", opcode, convertOpcode(opcode));

        switch (opcode) {
            // No handling needed for the hello and heartbeatAck packets
            case GatewayOpcodes.hello:
                auto op = deserializeJson!OpHello(jsonData["d"]);
                this._heartbeatInterval = op.heartbeat_interval;
                break;
            case GatewayOpcodes.heartbeatAck:
                infoLog("receieved heartbeat from discord gateway");
                break;
            case GatewayOpcodes.dispatch:
                // Dispatch
                processDispatchPacket(jsonData["t"].get!string, jsonData);
                break;
            default:
                warnLog("unimplemented packet opcode %d!", opcode);
                break;
        }
    }

    void processDispatchPacket(string type, Json json) {
        infoLog(json.toPrettyString);
        assert(_client !is null, "client was not set!");

        switch (type) {
            case "READY":
                auto packet = deserializeJson!ReadyPacket(json);
                infoLog("session id: %s, v: %d", packet.d.session_id, packet.d.v);
                _client.onReady(packet.d.user, packet.d.guilds, packet.d.v);
                break;
            case "MESSAGE_CREATE": 
                auto packet = deserializeJson!MessagePacket(json);
                _client.onMessage(packet.d);
                break;
            case "MESSAGE_DELETE":
                auto packet = deserializeJson!MessagePacket(json);
                _client.onMessageDeleted(packet.d);
                break;
            case "MESSAGE_REACTION_ADD":
                auto packet = deserializeJson!ReactionPacket(json);
                _client.onMessageReaction(packet.d.message_id, packet.d);
                break;

            /// GUILD
            case "GUILD_CREATE": 
                auto packet = deserializeJson!GuildPacket(json);
                _client.onGuildCreate(packet.d);
                break;
            default: break;
        }
    }

    /**
        vibe.d task to recieve packets from an active WebSocket connection
        and decode the content of them
     */
    void receivePacketsTask() {
        while (this._ws.connected) {

            // Return if we aren't waiting for any more data
            if (!this._ws.waitForData())
                return;

            // Decode the packet
            this.decodePacket(_ws.receiveText);
        }

        this._ws.close();
    }

    void identify(string token) {
        // Build a JSON payload to identify with

        struct Payload {
            int op;
            Nullable!string t, s;
            OpIdentify d;
        }

        auto properties = OpIdentifyProperties("decor", "decor", "pc");

        // stfu
        auto payload = Payload(GatewayOpcodes.identify, Nullable!string.init, Nullable!string.init, 
                               OpIdentify(token, properties));

        if (!this._ws.connected)
            return;

        _ws.send(serializeToJsonString!Payload(payload));
    }

public:
    /**  
     * Authenticates with the Discord HTTPS gateway
     * Params:
     *   token = the bot token, should never be revealed
     */
    void authenticate(string token) {
        infoLog("authenticating with the Discord HTTPS gateway..");

        string[string] headers;
        headers["Content-Type"] = "application/json";
        headers["Authorization"] = "Bot " ~ token;

        auto response = this.connectBot(token);

        // All is good, open a WebSocket connection
        infoLog("forwarding to WebSocket gateway (%s)..", response.url);
        this._webSocketUrl = response.url;

        connect(token);
    }

    /** 
     * Connects to the Discord WebSocket gateway and runs a task to
     * continuously receieve packets from the API.
     * Params:
     *   token = the bot token, should never be revealed
     */
    void connect(string token) {
        infoLog("connecting to the WebSocket gateway..");

        // Connect to the WebSocket gateway
        this._ws = connectWebSocket(URL(this._webSocketUrl));
        
        // Send heartbeat, then the identify payload
        identify(token);
        sendHeartbeat();

        // Start a timer to send a heartbeat to let Discord know we're still alive
        setTimer(20.seconds, toDelegate(&sendHeartbeat), true);

        runTask({ receivePacketsTask(); });
    }
}