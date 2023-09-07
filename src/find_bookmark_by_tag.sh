#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

function main {
  local BOOKMARKS_FILE=${1:-$HOME/.config/bookmarks/bookmarks.yaml}

  local TAG_LIST
  TAG_LIST=$(get_uniq_tags "$BOOKMARKS_FILE")
  local TAG
  TAG="$(make_dmenu_selection "$TAG_LIST")"

  local TITLE_LIST
  TITLE_LIST=$(get_title_list_by_tag "$TAG" "$BOOKMARKS_FILE")
  local TITLE
  TITLE="$(make_dmenu_selection "$TITLE_LIST")"

  local TITLE_QUOT_FIX
  TITLE_QUOT_FIX="$(add_two_back_slashes "$TITLE")"

  local URL
  URL="$(find_url_by_title "$TITLE_QUOT_FIX" "$BOOKMARKS_FILE")"

  # Auto type URL
  xdotool type "$URL"
}

BOOKMARKS_FILE="$HOME/.config/bookmarks/bookmarks.yaml"
main "${1:-"$BOOKMARKS_FILE"}"
