#!/usr/bin/env bash

get_title_list() {
  local YAML_FILE=$1
  local YQ="$HOME/.local/share/go/bin/yq"
  local TITLE_LIST

  TITLE_LIST=$("$YQ" '.[] | .title' "$YAML_FILE")
  echo "$TITLE_LIST"
}

# Faster version of removing head and tail char
# Ref: https://www.youtube.com/watch?v=QXineadwG4E
remove_head_tail_chars() {
  local STR=$1
  local CHAR=${2:-\"}

  local STR_TAIL="${STR#"$CHAR"}"
  echo "${STR_TAIL%"$CHAR"}"
}

make_dmenu_selection() {
  local LIST_DATA=$1
  # local DMENU="dmenu -i"
  local DMENU="rofi -dmenu -i"

  local LINES="-l 20"
  local FONT="-fn Inconsolata-14"
  local COLORS="-nb \#2C323E -nf \#9899a0 -sb \#BF616A -sf \#2C323E"

  echo "$LIST_DATA" | eval "$DMENU $LINES $FONT $COLORS"
}

find_url_by_title() {
  local TITLE=$1
  local BOOKMARKS_FILE=${2:-$HOME/.config/bookmarks/bookmarks.yaml}

  local YQ="$HOME/.local/share/go/bin/yq"
  # local SEARCH_CONDITION='.[] | select(.title == "'"$TITLE"'") | .url'
  # local SEARCH_CONDITION="'.[] | select(.title == \"""$TITLE""\") | .url'"
  local SEARCH_CONDITION=".[] | select(.title == \"""$TITLE""\") | .url"
  # echo "$SEARCH_CONDITION"

  local URL_QUOT
  URL_QUOT=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")
  remove_head_tail_chars "$URL_QUOT"
}

get_uniq_tags() {
  local BOOKMARKS_FILE=${1:-$HOME/.config/bookmarks/bookmarks.yaml}
  local YQ="$HOME/.local/share/go/bin/yq"

  TAGS=$("$YQ" '.[].tags[]' "$BOOKMARKS_FILE" | sort | uniq)
  echo "$TAGS"
}

get_title_list_by_tag() {
  local TAG=$1
  local BOOKMARKS_FILE=${2:-$HOME/.config/bookmarks/bookmarks.yaml}
  local YQ="$HOME/.local/share/go/bin/yq"

  local SEARCH_CONDITION=".[] | select(.tags[] == \"""$TAG""\") | .title"
  local TITLE_LIST
  TITLE_LIST=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")
  echo "$TITLE_LIST"
}

get_num_of_items() {
  local ITEMS=$1
  local NUM

  [[ -z "$ITEMS" ]] && NUM="0" || NUM=$(echo "$ITEMS" | wc -l)
  echo "$NUM"
}

# \" -> \\\"
add_two_back_slashes() {
  local STR=$1
  local OUTPUT
  OUTPUT="${STR//\"/\\\"}"
  echo "$OUTPUT"
}

get_selection_url() {
  local URL

  URL=$(xclip -o)
  echo "$URL"
}

get_input_title() {
  local TITLE
  # printf "What title?\n"
  # printf " : "
  # read -r TITLE
  read -r -p "title: " TITLE
  echo "$TITLE"
}

get_input_tags() {
  local TAGS 
  # printf "Any tags?\n"
  # printf " : "
  # read -r TAGS
  read -r -p "tags: " TAGS
  echo "$TAGS"
}

backup_bookmarks() {
  local SOURCE=$1
  local BACKUP_FILE=$2
  # cp "$BOOKMARKS_FILE" "$BOOKMARKS_BAK_FILE"
  cp "$SOURCE" "$BACKUP_FILE"
}

add_new_bookmark() {
  local URL=$1
  local TITLE=$2
  local TAGS=$3
  # YQ="/usr/bin/yq"
  local YQ="$HOME/.local/share/go/bin/yq"
  "$YQ" -i '. + {"url": "'"$URL"'", "title": "'"$TITLE"'", "tags": [ "'"$TAGS"'" ]}' "$BOOKMARKS_FILE"
}
