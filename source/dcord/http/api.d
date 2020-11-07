module dcord.http.api;

import vibe.core.core;
import vibe.http.client;
import vibe.data.json;

import dcord.http.client;

/**
    Abstraction over the Discord /channels/ endpoint
**/
class ChannelAPI
{
    import dcord.models;

public:
    string _token;

    this(string token) {
        this._token = token;
    }

    /// POST
    void sendMessage(string channelId, string content, bool isTts) {
        auto message = Message();
        message.channel_id = channelId;
        message.content = content;

        auto json = serializeToJson!Message(message);
        requestDiscordNull(HTTPMethod.POST, "/channels/"~channelId~"/messages", "json", this._token, (scope req) {
            req.writeJsonBody(json);
        });
    }

    /// sendMessage but with embed support
    void sendMessage(string channelId, Embed embed, bool isTts) {
        // not sure how i feel about this?
        struct CreateMessageParams {
            string content;
            Embed embed;
            bool tts;
        }

        auto params = CreateMessageParams("", embed, isTts);
        auto json = serializeToJson!CreateMessageParams(params);

        requestDiscordNull(HTTPMethod.POST, "/channels/"~channelId~"/messages", "json", this._token, (scope req) {
            req.writeJsonBody(json);
        });
    }

    /// GET
    Channel getChannel(string channelId) {
        return requestDiscordAs!Channel(HTTPMethod.GET, "/channels"~channelId, "json", this._token);
    }

    Message getMessage(string channelId, string messageId) {
        return requestDiscordAs!Message(HTTPMethod.GET, "/channels/"~channelId~"/messages/"~messageId, "json", this._token);
    }

    Message[] getMessages(string channelId, int limit = 50) {
        return requestDiscordAs!(Message[])(HTTPMethod.GET, "/channels/"~channelId~"/messages", "json", this._token);
    }
}

/**
 * Abstraction over the Discord /guilds/ endpoint
 */
class GuildAPI
{
    import dcord.models;

public:
    string _token;

    this(string token) {
        this._token = token;
    }

    /// GET
    Guild getGuild(string guildId) {
        return requestDiscordAs!Guild(HTTPMethod.GET, "/guilds/"~guildId, "json", this._token);
    }

    Channel[] getGuildChannels(string guildId) {
        return requestDiscordAs!(Channel[])(HTTPMethod.GET, "/guilds/"~guildId~"/channels", "json", this._token);
    }

    GuildMember[] getGuildMembers(string guildId) {
        return requestDiscordAs!(GuildMember[])(HTTPMethod.GET, "/guilds/"~guildId~"/members", "json", this._token);
    }

    GuildMember getGuildMember(string guildId, string userId) {
        return requestDiscordAs!GuildMember(HTTPMethod.GET, "/guilds/"~guildId~"/members/"~userId, "json", this._token);
    }

    Role[] getGuildRoles(string guildId) {
        return requestDiscordAs!(Role[])(HTTPMethod.GET, "/guilds/"~guildId~"/roles/", "json", this._token);
    }

}