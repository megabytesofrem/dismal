#!/bin/bash

# Copy the local source directory to the example bot
echo "Copying local source directory to basicbot using rsync"
rsync -av source/ examples/basicbot/source --exclude=bot.d --exclude app.d --exclude dub.json --exclude dub.selections.json --exclude .gitignore --exclude .dub

pushd examples/basicbot
echo "Attempting to run with dub, if this fails please use dub --force"
dub
popd
