module dismal.core.types;

/// TODO: Add a proper Snowflake type
alias Snowflake = ulong;

enum Colors : int
{
    // Material color palette
    // from https://material.io/resources/color/
    materialRed = 0xf44336,
    materialPink = 0xe91e63,
    materialPurple = 0x9c27b0,
    materialDeepPurple = 0x673ab7,
    materialBlue = 0x3f51b5,
    materialCyan = 0x00bcd4,
    materialLightGreen = 0x8bc34a,
    materialGreen = 0x4caf50,
    materialYellow = 0xffeb3b,
    materialOrange = 0xff9800,
    materialDeepOrange = 0xff5722,

    materialGray100 = 0xf5f5f5,
    materialGray200 = 0xeeeeee,
    materialGray300 = 0xe0e0e0,
    materialGray400 = 0xbdbdbd,
    materialGray500 = 0x9e9e9e,
    materialGray600 = 0x757575,
    materialGray700 = 0x616161,
    materialGray800 = 0x424242,
    materialGray900 = 0x212121,

    // Duplicate for UK/Canadian spelling
    materialGrey100 = materialGray100,
    materialGrey200 = materialGray200,
    materialGrey300 = materialGray300,
    materialGrey400 = materialGray400,
    materialGrey500 = materialGray500,
    materialGrey600 = materialGray600,
    materialGrey700 = materialGray700,
    materialGrey800 = materialGray800,
    materialGrey900 = materialGray900,

    materialWhite = materialGray100,
    materialBlack = materialGray900,

    // Discord branding colors
    discordBlurple = 0x7289da,
    discordLightDark = 0x2c2f33,
    discordDarkerDark = 0x23272a,
    discordBlack = black,

    // Misc.
    white = 0xffffff,
    black = 0x000000,
}

/// For UK/Canadian spelling
alias Colours = Colors;