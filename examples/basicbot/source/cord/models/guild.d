module cord.models.guild;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import cord.models.user;
import cord.models.role;
import cord.models.emoji;

/** https://discord.com/developers/docs/resources/guild */
struct GuildMember
{
    @optional PartialUser user;
    Nullable!string nick;
    string[] roles; // should be snowflake array
    string joined_at;
    @optional Nullable!string premium_since;
    bool deaf;
    bool mute;
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