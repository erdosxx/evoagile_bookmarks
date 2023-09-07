#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

BOOKMARKS_FILE="$HOME/.config/bookmarks/bookmarks.yaml"
BOOKMARKS_BAK_FILE="$HOME/.config/bookmarks/bookmarks.yaml.bak"

function main {
  local URL
  local TITLE
  local TAGS

  URL=$(get_selection_url)
  TITLE=$(get_input_title)
  TAGS=$(get_input_tags)

  backup_bookmarks "$BOOKMARKS_FILE" "$BOOKMARKS_BAK_FILE" 

  add_new_bookmark "$URL" "$TITLE" "$TAGS"
}

main
