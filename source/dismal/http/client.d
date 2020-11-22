module dismal.http.client;

import std.stdio;
import std.conv : to;
import std.format : format;
import std.functional : toDelegate;
import std.typecons : Nullable;
import std.json;

import vibe.core.core;
import vibe.inet.message;
import vibe.http.client;
import vibe.data.json;

import dismal.http.api;
import dismal.http.auth;
import dismal.logging.logger;

HTTPClientResponse requestDiscord(HTTPMethod method, string route, scope void delegate(scope HTTPClientRequest req) @safe requester = null) {
    auto res = requestHTTP("https://discordapp.com/api" ~ route, (scope req) {
        req.headers.addField("User-Agent", "decor (https://gitlab.com/chxrlotte/decor)");
        req.method = method;
        if (requester !is null)
            requester(req);
    });

    assert(res.statusCode != 404, "response got 404'd!");
    return res;
}

void requestDiscordNull(HTTPMethod method, 
                      string route, 
                      string type = "json",
                      AuthProvider auth = AuthProvider.none,
                      scope void delegate(scope HTTPClientRequest req) @safe requester = null) {
    auto res = requestDiscord(method, route, (scope req) {
        if (type == "json")
            req.headers.addField("Content-Type", "application/json");

        // Add an Authorization field if needed
        if (auth.getType == AuthType.secret)
            req.headers.addField("Authorization", "Bot " ~ auth.getUnderlyingToken);

        if (requester !is null)
            requester(req);
    });
}

T requestDiscordAs(T)(HTTPMethod method, 
                      string route, 
                      string type = "json",
                      AuthProvider auth = AuthProvider.none,
                      scope void delegate(scope HTTPClientRequest req) @safe requester = null) {
    auto res = requestDiscord(method, route, (scope req) {
        if (type == "json")
            req.headers.addField("Content-Type", "application/json");

        // Add an Authorization field if needed
        if (auth.getType == AuthType.secret)
            req.headers.addField("Authorization", "Bot " ~ auth.getUnderlyingToken);

        if (requester !is null)
            requester(req);
    });

    return deserializeJson!T(res.readJson());
}

/**
 * Client class to interact with the Discord HTTP API
 */
class DiscordHTTPClient
{
    import dismal.models;
    import dismal.http.api;
    import dismal.http.auth;
    import dismal.core.gateway : HTTPGatewayResponse;

private:
    string _token;
    string _baseRoute;

    @property string token() { return _token; }

public:
    ChannelAPI channel;
    GuildAPI guild;

    this(string token) {
        this._token = token;

        this.channel = new ChannelAPI(AuthProvider.secretToken(this._token));
        this.guild = new GuildAPI(AuthProvider.secretToken(this._token));
    }
}