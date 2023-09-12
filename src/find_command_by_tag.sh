#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

function main {
  local BOOKMARKS_FILE=${1:-$HOME/.config/bookmarks/commands.yaml}

  local TAG_LIST
  TAG_LIST=$(get_uniq_tags "$BOOKMARKS_FILE")
  local TAG
  TAG="$(make_dmenu_selection "$TAG_LIST")"

  local TITLE_LIST
  TITLE_LIST=$(get_title_list_by_tag "$TAG" "$BOOKMARKS_FILE")

  local TITLE
  if [[ $(get_num_of_items "$TITLE_LIST") -eq "0" ]]; then
    # No selection of tag
    exit
  elif [[ $(get_num_of_items "$TITLE_LIST") -eq "1" ]]; then
    TITLE="$TITLE_LIST"
  else
    TITLE="$(make_dmenu_selection "$TITLE_LIST")"
    [[ -z "$TITLE" ]] && exit
  fi

  local TITLE_QUOT_FIX
  TITLE_QUOT_FIX="$(add_two_back_slashes "$TITLE")"

  local CMD
  CMD="$(find_url_by_title "$TITLE_QUOT_FIX" "$BOOKMARKS_FILE")"

  xdotool type "$CMD"
}

BOOKMARKS_FILE="$HOME/.config/bookmarks/commands.yaml"
main "${1:-"$BOOKMARKS_FILE"}"
