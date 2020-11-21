module dismal.models.message;

import std.typecons : Nullable;
import vibe.data.json;
import vibe.data.serialization;

import dismal.core.types;
import dismal.models;

struct Message
{
    string id;
    string channel_id;
    @optional Nullable!string guild_id;
    @optional PartialUser author;
    @optional string content;
    @optional string timestamp;
    @optional bool mention_everyone;
    @optional PartialUser[] mentions;
    @optional Embed[] embeds;
    @optional bool pinned;
}

struct MessageReaction
{
    string message_id;
    string channel_id;
    string guild_id;
    
    GuildMember member;
    Emoji emoji;
}