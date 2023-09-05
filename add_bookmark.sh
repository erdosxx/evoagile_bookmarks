#!/bin/bash

BOOKMARKS_FILE="$HOME/.config/bookmarks/bookmarks.yaml"
BOOKMARKS_BAK_FILE="$HOME/.config/bookmarks/bookmarks.yaml.bak"

URL=$(xclip -o)
echo $URL

printf "What title?\n"
printf " : "
read -r TITLE
echo $TITLE

printf "Any tags?\n"
printf " : "
read -r TAG
echo $TAG

cp $BOOKMARKS_FILE $BOOKMARKS_BAK_FILE
yq -i '. + {"url": "'"$URL"'", "title": "'"$TITLE"'", "tags": [ "'"$TAG"'" ]}' $BOOKMARKS_FILE
