module dcord.models.emoji;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dcord.models.role;
import dcord.models.user;

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