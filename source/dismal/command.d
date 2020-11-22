module dismal.command;

import dismal.client : Client;
import dismal.core.permission;
import dismal.models;

import dismal.logging.logger;

/** 
 * Command struct
 */
struct Command
{
    // @Command("help", "displays help for the bot", ["READ_MESSAGES"], false)
    string[] aliases;
    string description;
    int[] permissions;
    bool ownerOnly;
}

/** 
 * Utility struct to hold a command and a handler function
 */
struct CommandFunction
{
    Command command;
    void delegate(Client client, Message msg, string commandName, string[] args) handlerFn;
}

class CommandHandler
{
    CommandFunction[] commands;

public:
    string prefix;

    this(string prefix) {
        this.prefix = prefix;
    }

    /** 
     * Register a module class containing multiple @Command UDAs
     */
    void registerModuleClass(T)(T t) {
        // @Command uda

        infoLog("registering new module class for %s", t);
        foreach (mem; __traits(allMembers, T)) {
            foreach (attr; __traits(getAttributes, __traits(getMember, T, mem))) {
                static if (is(typeof(attr) == Command)) {
                    auto handlerFn = &__traits(getMember, t, mem);

                    // Require a handler to be associated with each command
                    assert(handlerFn !is null, "command handler not specified");
                    this.commands ~= CommandFunction(attr, handlerFn);
                }
            }
        }
    }
    
    /** 
     * Parse a command from a Message object and handle it 
     * Params:
     *   client = instance of cord.client
     *   msg = the Message object (from onMessage event)
     */
    void parseCommand(Client client, Message msg) {
        import dismal.logging.logger;
        import std.string : split;

        import dismal.util.member;

        // Parse the command into its individual parts
        auto commandName = msg.content.split(" ")[0][this.prefix.length .. $];
        auto rest = msg.content.split(" ")[1 .. $];

        PermissionFlag totalPermissions;
        auto member = client.http.guild.getGuildMember(msg.guild_id, msg.author.id);
        auto memberRoles = getMemberRoles(client.http, msg.guild_id, member);

        foreach (command; commands) {
            // TODO: clean this up wtf
            foreach (alias_; command.command.aliases) {
                if (alias_ == commandName) {
                    // Check if we have permissions to run the command
                    if (command.command.permissions.length == 0) {
                        command.handlerFn(client, msg, commandName, rest);
                        break;
                    }

                    // Set all the permission flags
                    foreach (pf; command.command.permissions) {
                        setPermission(totalPermissions, cast(PermissionFlag) pf);
                    }

                    foreach (role; memberRoles) {
                        if (checkPermission(cast(PermissionFlag) role.permissions, totalPermissions)) {
                            command.handlerFn(client, msg, commandName, rest);
                            break;
                        }
                    }
                }
            }
        }
    }
}