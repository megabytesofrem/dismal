module cord.util.embed;

import cord.models;

/**
 * Helper class to build embeds, inspired from discord.js EmbedBuilder class
 */
class EmbedBuilder 
{
private:
    static Embed _embed;

public:
    static EmbedBuilder withTitle(string title) {
        this._embed.title = title;
        return new EmbedBuilder();
    }

    static EmbedBuilder withDescription(string description) {
        this._embed.description = description;
        return new EmbedBuilder();
    }

    static EmbedBuilder withColor(int color) {
        this._embed.color = color;
        return new EmbedBuilder();
    }

    static Embed buildEmbed() {
        return this._embed;
    }
}