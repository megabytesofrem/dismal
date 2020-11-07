module dcord.models.embed;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dcord.models.role;
import dcord.models.user;

struct Embed
{
    @optional string title;
    @optional string type;
    @optional string description;
    @optional string url;
    @optional string timestamp;
    @optional int color;
    @optional PartialUser author;
}