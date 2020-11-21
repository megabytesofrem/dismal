module bot;

import std.string;

import dismal.client;
import dismal.logging.logger;
import dismal.models;

import dismal.command;

class MyClient : Client
{
    import commands : Commands;

public:
    CommandHandler handler = new CommandHandler("d.");

    override void onReady(PartialUser user, Guild[] guilds, int discordVersion) {
        infoLog("connected with %s#%s", user.username, user.discriminator);

        // Register our new ping command here
        handler.registerModuleClass(new Commands());
    }

    override void onMessage(Message msg) {
        if (msg.author.bot)
            return;

        if (msg.content.startsWith("d.")) {
            handler.handleCommand(this, msg);
        }
    }
}
