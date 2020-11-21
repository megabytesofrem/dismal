module dismal.util.guild;

import std.conv : to;
import std.typecons : Nullable;

import dismal.core.permission;
import dismal.models;

bool checkGuildPermissions(Guild guild, PermissionFlag flags...) {
    PermissionFlag pf;
    pf |= flags;

    // Check the permission flag pf
    string permissionString = guild.permissions.get;
    PermissionFlag target = cast(PermissionFlag)permissionString.to!int;

    // Bounds check
    assert(pf >= 0x00 || target >= 0x00, "permission flag should never go below 0");
    return checkPermission(target, pf);
}