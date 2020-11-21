module dismal.util.embed;

import dismal.models;

/**
 * Helper class to build embeds, inspired from discord.js EmbedBuilder class
 */
class EmbedBuilder 
{
private:
    static Embed singleton;

public:
    static EmbedBuilder withTitle(string title) {
        this.singleton.title = title;
        return new EmbedBuilder();
    }

    static EmbedBuilder withDescription(string description) {
        this.singleton.description = description;
        return new EmbedBuilder();
    }

    static EmbedBuilder withFooter(string text, string url = "") {
        this.singleton.footer.text = text;

        if (url != "")
            this.singleton.footer.icon_url = url;
        return new EmbedBuilder();
    }

    static EmbedBuilder withColor(int color) {
        this.singleton.color = color;
        return new EmbedBuilder();
    }

    static EmbedBuilder withField(string name, string value) {
        this.singleton.fields ~= EmbedField(name, value, false);
        return new EmbedBuilder();
    }

    static EmbedBuilder withInlineField(string name, string value) {
        this.singleton.fields ~= EmbedField(name, value, true);
        return new EmbedBuilder();
    }

    static Embed buildEmbed() {
        return this.singleton;
    }
}