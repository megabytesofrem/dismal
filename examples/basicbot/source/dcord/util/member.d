module dcord.util.member;

import std.string;
import std.typecons : Nullable;
import std.algorithm.iteration : filter;

import dcord.http.client;
import dcord.models;

Nullable!GuildMember findMember(DiscordHTTPClient client, string guildId, string memberId) {
    assert(client !is null, "client passed to findMember was null");
    auto members = client.guild.getGuildMembers(guildId);
    auto result = members.filter!(m => m.user.id == memberId);
    
    return Nullable!GuildMember(result.front);
}