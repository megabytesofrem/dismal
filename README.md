# dcord
Work in progress Discord API wrapper for D lang.

## Features
- Detailed models to represent gateway responses as D `struct`s
- Decoding basic gateway responses (`DISPATCH` packets) eg `MESSAGE_CREATE`, `GUILD_CREATE`
- Interacting with the HTTP API via an abstract wrapper using `DiscordHTTPClient`
- Providing a class to create a basic bot from that abstracts
  all the complex gateway logic away from the user of the API.

## Basic Example
A basic example for creating a bot using dcord can be found under `examples/basicbot/source`. Please note that you will need to edit
the `token` variable and provide your own bot token.

If you wish to test it, run `./test.sh` to copy the library files and run the example bot