module cord.models.channel;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import cord.models.user;

enum ChannelType
{
    guildText,
    dm,
    guildVoice,
    guildDm,
    guildCategory,
    guildNews,
    guildStore
}

/** https://discord.com/developers/docs/resources/channel */
struct Channel
{
    string id; // should be snowflake
    ChannelType type;
    @optional string guild_id;
    @optional int position;
    @optional string name;
    @optional Nullable!string topic;
    @optional bool nsfw;
    @optional Nullable!string last_message_id;

    // Voice channel specific
    @optional int bitrate;
    @optional int user_limit;

    // DM specific
    @optional string owner_id;
    @optional string application_id;
    @optional PartialUser[] recipients;
}