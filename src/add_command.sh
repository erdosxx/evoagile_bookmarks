#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

CMD_FILE="$HOME/.config/bookmarks/commands.yaml"
CMD_BAK_FILE="$HOME/.config/bookmarks/commands.yaml.bak"

main() {
  local CMD_INPUT
  local CMD
  local TITLE
  local TAGS
  local TAGS_STR

  CMD_INPUT="$(get_clip_str)"
  echo "CMD: $CMD_INPUT"

  CMD=$(rm_tail_slash "$CMD_INPUT")

  if [[ $(get_num_url "$CMD" "$CMD_FILE") -ne "0" ]]; then
    echo "The CMD is already exist in commands file."
    sleep 2
    exit
  fi

  TITLE="$(get_input_title)"
  [[ "$TITLE" == "q!" ]] && exit

  while [[ $(get_num_title "$TITLE" "$CMD_FILE") -ne "0" ]]; do
    echo "The title is already used. Try to use other title."
    TITLE=$(get_input_title)
  done

  echo "Add tags with , delimiter, for example, three tags => abc, de & fg, hi"
  TAGS="$(get_input_tags)"
  TAGS_STR=$(gen_tags_str "$TAGS")

  backup_file "$CMD_FILE" "$CMD_BAK_FILE" 

  add_new_entry "$CMD" "$TITLE" "$TAGS_STR" "$CMD_BAK_FILE" > "$CMD_FILE"
}

main
