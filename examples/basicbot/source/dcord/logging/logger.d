module dcord.logging.logger;

import colorize : fg, color, cwriteln, cwritefln;

void infoLog(Char, T...)(in Char[] fmt, T args) {
    cwritefln("[INFO] ".color(fg.light_black) ~ fmt, args);
}

void warnLog(Char, T...)(in Char[] fmt, T args) {
    cwritefln("[WARN] ".color(fg.yellow) ~ fmt, args);
}

void errorLog(Char, T...)(in Char[] fmt, T args, bool isFatal) {
    auto prefix = (isFatal) ? "[FATAL] " : "[ERROR] ";
    cwritefln(prefix.color(fg.red) ~ fmt, args);
}