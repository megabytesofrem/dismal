module bot;

import std.string;

// cord imports
import cord.client;
import cord.logging.logger;
import cord.models;

import cord.util.embed;

class MyClient : Client
{
    override void onReady(PartialUser user, Guild[] guilds, int discordVersion) {
        infoLog("connected with %s#%s", user.username, user.discriminator);
    }

    override void onMessage(Message msg) {
        if (msg.author.bot)
            return;

        if (!msg.content.startsWith("d."))
            return;

        auto command = msg.content[2 .. $];
        if (command == "ping") {
            this.http.channel.sendMessage(msg.channel_id, "pong!", false);
        }
        else if (command == "about") {
            //auto embedBuilder = new EmbedBuilder();
            auto embed = EmbedBuilder.withTitle("Test embed")
                                     .withDescription("Description of a test embed made in decor")
                                     .withColor(0xffb8ed)
                                     .buildEmbed();

            this.http.channel.sendMessage(msg.channel_id, embed, false);
        }
    }
}
