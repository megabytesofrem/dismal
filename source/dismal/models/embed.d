module dismal.models.embed;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dismal.models.role;
import dismal.models.user;

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