module cord.core.opcodes;

import std.typecons : Nullable;
import vibe.data.json;
import vibe.data.serialization;

/** 
 * Decode an opcode into a human readable form
 *
 * Returns: a string representation of the opcode 
 */
string convertOpcode(int op) {
    switch (op) {
        case GatewayOpcodes.hello: return "hello";
        case GatewayOpcodes.dispatch: return "dispatch";
        case GatewayOpcodes.identify: return "identify";
        case GatewayOpcodes.heartbeat: return "heartbeat";
        case GatewayOpcodes.heartbeatAck: return "heartbeat ack";
        case GatewayOpcodes.reconnect: return "reconnect";
        case GatewayOpcodes.requestGuildMembers: return "req guild members";
        case GatewayOpcodes.resume: return "resume";
        case GatewayOpcodes.statusUpdate: return "status update";
        case GatewayOpcodes.invalidSession: return "invalid session";
        default: return "not supported";
    }
}

/**
 * Gateway opcodes (not all are used)
 */
enum GatewayOpcodes : int
{
    dispatch = 0,
    heartbeat = 1,
    identify = 2,
    statusUpdate = 3,
    resume = 6,
    reconnect = 7,
    requestGuildMembers = 8,
    invalidSession = 9,
    hello = 10,
    heartbeatAck = 11
}

struct OpHello
{
    int heartbeat_interval;
}

struct OpIdentifyProperties
{
    @name("$os") string os;
    @name("$browser") string browser;
    @name("$device") string device;
}

struct OpIdentify
{
    string token;
    //@embedNullable Nullable!int intents;
    OpIdentifyProperties properties;
}

struct OpHeartbeat
{
    @name("d") Nullable!int lastSequenceNumber; // null if we don't have one
}

struct HeartbeatPayload
{
    int op;
    OpHeartbeat d;
}

struct OpResume
{
    string token;
    string session_id;

    @name("seq") int lastSequenceNumber;
}

