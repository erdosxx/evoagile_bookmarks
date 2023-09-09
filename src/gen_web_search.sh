#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
source "$SRC_DIR"/functions_lib.sh

function main {
  local SEARCH_INPUT_STR
  SEARCH_INPUT_STR="$(get_clip_str)"

  SEARCH_STR=$(gen_search_str "$SEARCH_INPUT_STR")

  local SEARCH_URL_FILE=${1:-$HOME/.config/bookmarks/search_url.yaml}

  local SEARCH_ENGINE_LIST
  SEARCH_ENGINE_LIST=$(get_title_list "$SEARCH_URL_FILE")
  local SEARCH_ENGINE
  SEARCH_ENGINE="$(make_dmenu_selection "$SEARCH_ENGINE_LIST" "$SEARCH_INPUT_STR")"

  [[ -z "$SEARCH_ENGINE" ]] && exit

  local URL
  URL="$(find_url_by_title "$SEARCH_ENGINE" "$SEARCH_URL_FILE")"

  # Auto type URL
  xdotool type "$URL""$SEARCH_STR"
}

SEARCH_URL_FILE="$HOME/.config/bookmarks/search_url.yaml"
main "${1:-"$SEARCH_URL_FILE"}"
