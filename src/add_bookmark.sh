#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

BOOKMARKS_FILE="$HOME/.config/bookmarks/bookmarks.yaml"
BOOKMARKS_BAK_FILE="$HOME/.config/bookmarks/bookmarks.yaml.bak"

function main {
  local URL_INPUT
  local URL
  local TITLE
  local TAGS
  local TAGS_STR

  URL_INPUT="$(get_clip_str)"
  echo "URL: $URL_INPUT"

  URL=$(rm_tail_slash "$URL_INPUT")

  if [[ $(get_num_url "$URL" "$BOOKMARKS_FILE") -ne "0" ]]; then
    echo "The URL is already exist in bookmark."
    sleep 2
    exit
  fi

  TITLE="$(get_input_title)"
  [[ "$TITLE" == "q!" ]] && exit

  while [[ $(get_num_title "$TITLE" "$BOOKMARKS_FILE") -ne "0" ]]; do
    echo "The title is already used. Try to use other title."
    TITLE=$(get_input_title)
  done

  echo "Add tags with , delimiter, for example, three tags => abc, de & fg, hi"
  TAGS="$(get_input_tags)"
  TAGS_STR=$(gen_tags_str "$TAGS")

  backup_bookmarks "$BOOKMARKS_FILE" "$BOOKMARKS_BAK_FILE" 

  # echo "$(add_new_bookmark "$URL" "$TITLE" "$TAGS_STR" "$BOOKMARKS_BAK_FILE")" > "$BOOKMARKS_FILE"
  add_new_bookmark "$URL" "$TITLE" "$TAGS_STR" "$BOOKMARKS_BAK_FILE" > "$BOOKMARKS_FILE"
}

main
