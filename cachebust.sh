#!/bin/sh

cd "$HOME/liberfysite" || exit
timestamp=$(date +%s)

# This command carefully targets href and src attributes to append the timestamp,
# avoiding unintended replacements elsewhere.
sed -i.bak -E "s/(href|src)=\"([^\"]+\.(png|ico|js|css|webmanifest))(\?[^\"]*)?\"/\1=\"\2?${timestamp}\"/g" html/index.html && rm html/index.html.bak
