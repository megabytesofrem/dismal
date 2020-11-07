module dcord.client;

import dcord.core.gateway;
import dcord.http.client;
import dcord.models;

interface IClient
{
    /// TODO: Implement more events here
    void onReady(PartialUser user, Guild[] guilds, int discordVersion);
    void onMessage(Message msg);
    void onMessageEdited(Message msg);
    void onMessageDeleted(Message msg);
    void onMessageReaction(string messageId, MessageReaction reaction);
    void onGuildCreate(Guild guild);
}

class Client : IClient
{
private:
    string _token;
    Gateway _gateway;
    DiscordHTTPClient _httpClient;

public:
    @property DiscordHTTPClient http() { return this._httpClient; }

    void login(string token) {
        this._gateway = new Gateway();
        this._gateway._client = this;
        this._gateway.authenticate(token);

        // Create a HTTP client for sending requests
        this._httpClient = new DiscordHTTPClient(token);
    }

    // Event stubs
    void onReady(PartialUser user, Guild[] guilds, int discordVersion) { }

    // MESSAGE
    void onMessage(Message msg) { }
    void onMessageEdited(Message msg) { }
    void onMessageDeleted(Message msg) { }
    void onMessageReaction(string messageId, MessageReaction reaction) { }

    // GUILD
    void onGuildCreate(Guild guild) { }
}