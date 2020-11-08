module cord.models.user;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

/** https://discord.com/developers/docs/resources/user */
struct PartialUser
{
    string id;
    string username;
    string discriminator;
    Nullable!string avatar;
    @optional bool bot;
    @optional bool mfa_enabled;
    @optional bool verified;
    @optional Nullable!string email;
}