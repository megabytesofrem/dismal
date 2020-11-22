module dismal.models.guild;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dismal.models.user;
import dismal.models.role;
import dismal.models.emoji;

/** https://discord.com/developers/docs/resources/guild */

struct GuildMember
{
    @optional PartialUser user;
    @optional Nullable!string nick;
    @optional string[] roles; // should be snowflake array
    @optional string joined_at;
    @optional Nullable!string premium_since;
    @optional bool deaf;
    @optional bool mute;
}

struct Guild
{
    string id; // should be snowflake
    bool unavailable;
    @optional Nullable!string afk_channel_id;
    @optional Nullable!string application_id;
    @optional int afk_timeout;
    @optional string name;
    @optional Nullable!string icon;
    @optional Nullable!string icon_hash;
    @optional Nullable!bool splash;
    @optional Nullable!string discovery_splash;
    @optional Nullable!bool owner;
    @optional string owner_id; // should be snowflake
    @optional Nullable!string permissions;
    @optional GuildMember[] members;
    @optional Role[] roles;
    @optional Emoji[] emojis;
}