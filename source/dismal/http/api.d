module dismal.http.api;

import std.typecons : Nullable;
import std.range : front;
import std.algorithm.searching;

import vibe.core.core;
import vibe.http.client;
import vibe.data.json;

import dismal.http.client;
import dismal.http.auth;

/**
 * Abstraction over the Discord /channels/ endpoint
**/
class ChannelAPI
{
    import dismal.models;

public:
    AuthProvider auth;

    this(AuthProvider auth) {
        this.auth = auth;
    }

    /// POST
    void sendMessage(string channelId, string content, bool isTts) {
        auto message = Message();
        message.channel_id = channelId;
        message.content = content;

        auto json = serializeToJson!Message(message);
        requestDiscordNull(HTTPMethod.POST, "/channels/"~channelId~"/messages", "json", auth, (scope req) {
            req.writeJsonBody(json);
        });
    }

    /// sendMessage but with embed support
    void sendMessage(string channelId, Embed embed, bool isTts) {
        // not sure how i feel about this?
        struct Params {
            string content;
            Embed embed;
            bool tts;
        }

        auto params = Params("", embed, isTts);
        auto json = serializeToJson!Params(params);

        requestDiscordNull(HTTPMethod.POST, "/channels/"~channelId~"/messages", "json", auth, (scope req) {
            req.writeJsonBody(json);
        });
    }

    /// GET
    Channel getChannel(string channelId) {
        return requestDiscordAs!Channel(HTTPMethod.GET, "/channels/"~channelId, "json", auth);
    }

    Message getMessage(string channelId, string messageId) {
        return requestDiscordAs!Message(HTTPMethod.GET, "/channels/"~channelId~"/messages/"~messageId, "json", auth);
    }

    Message[] getMessages(string channelId, int limit = 50) {
        return requestDiscordAs!(Message[])(HTTPMethod.GET, "/channels/"~channelId~"/messages", "json", auth);
    }
}

/**
 * Abstraction over the Discord /guilds/ endpoint
 */
class GuildAPI
{
    import dismal.models;

public:
    AuthProvider auth;

    this(AuthProvider auth) {
        this.auth = auth;
    }

    void kickMember(string guildId, string userId) {
        requestDiscordNull(HTTPMethod.DELETE, "/guilds/"~guildId~"/members/"~userId, "json", auth, (scope req) {
            //req.writeJsonBody(json);
        });
    }

    void banMember(string guildId, string userId, string reason = "", int deleteMessageDays = 0) {
        struct Params {
            int delete_message_days;
            string reason;
        }

        auto params = Params(deleteMessageDays, reason);
        auto json = serializeToJson!Params(params);

        requestDiscordNull(HTTPMethod.PUT, "/guilds/"~guildId~"/bans/"~userId, "json", auth, (scope req) {
            req.writeJsonBody(json);
        });
    }

    void unbanMember(string guildId, string userId) {
        requestDiscordNull(HTTPMethod.DELETE, "/guilds/"~guildId~"/bans/"~userId, "json", auth, (scope req) {
            //req.writeJsonBody(json);
        });
    }

    /// GET
    Guild getGuild(string guildId) {
        return requestDiscordAs!Guild(HTTPMethod.GET, "/guilds/"~guildId, "json", auth);
    }

    Channel[] getGuildChannels(string guildId) {
        return requestDiscordAs!(Channel[])(HTTPMethod.GET, "/guilds/"~guildId~"/channels", "json", auth);
    }

    Channel getGuildChannel(string guildId, string channelId) {
        auto channels = getGuildChannels(guildId);
        Channel chan = channels.find!((c) => c.id == channelId).front;
        return chan;
    }

    GuildMember[] getGuildMembers(string guildId) {
        return requestDiscordAs!(GuildMember[])(HTTPMethod.GET, "/guilds/"~guildId~"/members", "json", auth);
    }

    GuildMember getGuildMember(string guildId, string userId) {
        return requestDiscordAs!GuildMember(HTTPMethod.GET, "/guilds/"~guildId~"/members/"~userId, "json", auth);
    }

    Role[] getGuildRoles(string guildId) {
        return requestDiscordAs!(Role[])(HTTPMethod.GET, "/guilds/"~guildId~"/roles", "json", auth);
    }

    Nullable!Role getGuildRole(string guildId, string roleId) {
        import std.stdio : writefln;

        auto roles = getGuildRoles(guildId);
        foreach (role; roles) {
            writefln("role id: %s, name: %s", role.id, role.name);
        }

        Role role = roles.find!((r) => r.id == roleId).front;
        return Nullable!Role(role);
    }
}