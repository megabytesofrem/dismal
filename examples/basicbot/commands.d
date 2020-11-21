module examples.basicbot.commands;

import dismal.client;
import dismal.model;

class Commands 
{
    @Command("ping", "replies with ping", [], false)
    void pingCommand(Client client, Message msg, string commandName, string[] args) {
        client.http.channel.sendMessage(msg.channel_id, "pong!", false);
    }
}