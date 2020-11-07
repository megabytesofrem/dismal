module dcord.core.packets;

import dcord.models;

import vibe.data.json;
import vibe.data.serialization;

/**
 * Base packet class
 */
class BasePacket 
{
    int op;

    @name("t")
    string type;

    @name("s")
    int shard; // shard?
}


class ReadyPacket : BasePacket
{
    import dcord.models.user : PartialUser;
    import dcord.models.guild : Guild;

    // Define the data inline instead of using a model since
    // we never need to create this manually and don't care about it much

    // Actually, we may regret this later but for now its safe to just pass
    // what we need only to client.onReady..
    struct Data
    {
        string session_id;
        string[] relationships;
        string[] private_channels;
        int v;
        PartialUser user;
        Guild[] guilds;
    }

    Data d;
}

class MessagePacket : BasePacket
{
    Message d;
}

class GuildPacket : BasePacket
{
    Guild d;
}

class ReactionPacket : BasePacket
{
    MessageReaction d;
}