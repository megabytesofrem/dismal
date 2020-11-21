module dismal.util.member;

import std.string;
import std.typecons : Nullable;
import std.algorithm : canFind;
import std.algorithm.iteration : filter;

import dismal.http.client;
import dismal.core.permission;
import dismal.models;

Nullable!GuildMember findMemberNamed(DiscordHTTPClient client, string guildId, string memberName, string discrim) {
    assert(client !is null, "client passed to findMember was null");
    auto members = client.guild.getGuildMembers(guildId);
    auto result = members.filter!(m => m.user.username == memberName && m.user.discriminator == discrim);
    
    return Nullable!GuildMember(result.front);
}

/** 
 * Helper method to check whether a member has a role 
 * Returns: 
 */
bool memberHasRole(GuildMember member, Role role) {
    return member.roles.canFind(role.id);
}