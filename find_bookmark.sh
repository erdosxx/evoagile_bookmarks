#!/bin/sh

# YQ="/usr/bin/yq"
YQ="$HOME/.local/share/go/bin/yq"
# YQ="$HOME/.local/share/go/bin/yq"
# DMENU="dmenu -i"
DMENU="rofi -dmenu -i"

BOOKMARKS_FILE="$HOME/.config/bookmarks/bookmarks.yaml"

LINES="-l 20"
FONT="-fn Inconsolata-14"
COLORS="-nb #2C323E -nf #9899a0 -sb #BF616A -sf #2C323E"

# TITLE_QUOTATION=$(yq '.[] | .title' $BOOKMARKS_FILE | dmenu -i -l 50 -fn "Inconsolata Nerd Font":size=16)
TITLE_QUOTATION=$($YQ '.[] | .title' $BOOKMARKS_FILE | $DMENU $LINES $FONT $COLORS)
TITLE=$(echo $TITLE_QUOTATION | sed 's/"//g')

URL_QUOTATION=$($YQ ".[] | select(.title == \"$TITLE\") | .url" $BOOKMARKS_FILE)
URL=$(echo $URL_QUOTATION | sed 's/"//g')
xdotool type $URL
