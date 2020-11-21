module dismal.models.embed;

import vibe.data.json;
import vibe.data.serialization;
import std.typecons : Nullable;

import dismal.models.role;
import dismal.models.user;

struct Embed
{
    // TODO: support image embeds (form/multipart probably)

    @optional string title;
    @optional string type;
    @optional string description;
    @optional string url;
    @optional string timestamp;
    @optional int color;
    @optional EmbedAuthor author;
    @optional EmbedField[] fields;
    @optional EmbedFooter footer;
}

struct EmbedAuthor
{
    @optional string name;
    @optional string url;
    @optional string icon_url;
    @optional string proxy_icon_url;
}

struct EmbedField
{
    string name;
    string value;
    @optional bool inline;
}

struct EmbedFooter
{
    @optional string text;
    @optional string icon_url;
    @optional string proxy_icon_url;
}