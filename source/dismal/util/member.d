module dismal.util.member;

import std.string;
import std.typecons : Nullable;
import std.algorithm : canFind;
import std.algorithm.iteration : filter;

import dismal.http.client;
import dismal.core.permission;
import dismal.models;

GuildMember findMemberNamed(DiscordHTTPClient client, string guildId, string memberName, string discrim) {
    assert(client !is null, "client passed to findMember was null");
    auto members = client.guild.getGuildMembers(guildId);
    auto result = members.filter!(m => m.user.username == memberName && m.user.discriminator == discrim);
    
    return result.front;
}

/** 
 * Helper method to get a role by its name, from a specific guild (by its id)
 * Returns: 
 */
Nullable!Role getMemberRole(DiscordHTTPClient client, string guildId, GuildMember member, string roleName) {
    import std.algorithm.searching : find;
    import std.range : front;

    Role[] roles = client.guild.getGuildRoles(guildId);

    Role role = roles.find!((r) => r.name == roleName).front;
    if (hasRole(member, role))
        return Nullable!Role(role);

    return Nullable!Role.init;
}

/** 
 * Helper method to check whether a member has a role 
 * Returns: 
 */
bool hasRole(GuildMember member, Role role) {
    return member.roles.canFind(role.id);
}