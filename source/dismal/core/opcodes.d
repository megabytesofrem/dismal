module dismal.core.opcodes;

import std.stdio;
import std.typecons : Nullable;
import vibe.data.json;
import vibe.data.serialization;

/** 
 * Decode an opcode into a human readable form using D magic
 *
 * Returns: a string representation of the opcode 
 */
string convertOpcode(int op) {
    import std.traits : EnumMembers;
    import std.conv : to;
    static foreach (member; EnumMembers!GatewayOpcodes) {
        if (op == cast(int)member)
            return member.to!string;
    }

    // should never get here
    return "";
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

