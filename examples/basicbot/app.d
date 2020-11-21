import std.stdio;
import std.format;
import vibe.core.core;

import bot;

void main() {
	const string token = "<token>";
	auto client = new MyClient();

	client.login(token);
	runApplication();
}
