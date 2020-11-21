module dismal.models.emoji;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dismal.models.role;
import dismal.models.user;

struct Emoji
{
    Nullable!string id;
    Nullable!string name;
    @optional Role[] roles;
    @optional PartialUser user;
    @optional bool managed;
    @optional bool animated;
    @optional bool available;
}