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
  local PROMPT=$2

  local LINES="-l 20"
  local FONT="-fn Inconsolata-14"
  local COLORS="-nb \#2C323E -nf \#9899a0 -sb \#BF616A -sf \#2C323E"

  if [[ -z "$PROMPT" ]]; then
    echo "$LIST_DATA" | rofi -dmenu -i  "$LINES" "$FONT" "$COLORS"
  else
    echo "$LIST_DATA" | rofi -dmenu -i  "$LINES" "$FONT" "$COLORS" -p "$PROMPT"
  fi
}

find_url_by_title() {
  local TITLE=$1
  local BOOKMARKS_FILE=${2:-$HOME/.config/bookmarks/bookmarks.yaml}

  local YQ="$HOME/.local/share/go/bin/yq"
  local SEARCH_CONDITION=".[] | select(.title == \"""$TITLE""\") | .url"

  local URL_QUOT
  URL_QUOT=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")
  remove_head_tail_chars "$URL_QUOT"
}

get_num_url() {
  local URL=$1
  local BOOKMARKS_FILE=${2:-$HOME/.config/bookmarks/bookmarks.yaml}

  local YQ="$HOME/.local/share/go/bin/yq"
  local SEARCH_CONDITION=".[] | select(.url == \"""$URL""\") | .url"

  local URL_QUOT
  URL_QUOT=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")

  get_num_of_items "$URL_QUOT"
}

get_num_title() {
  local TITLE=$1
  local BOOKMARKS_FILE=${2:-$HOME/.config/bookmarks/bookmarks.yaml}

  local YQ="$HOME/.local/share/go/bin/yq"
  local SEARCH_CONDITION=".[] | select(.title == \"""$TITLE""\") | .title"

  local SEARCH_TITLE
  SEARCH_TITLE=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")

  get_num_of_items "$SEARCH_TITLE"
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

rm_tail_slash() {
  local STR=$1
  echo ${STR%\/}
}

# \" -> \\\"
add_two_back_slashes() {
  local STR=$1
  local OUTPUT
  OUTPUT="${STR//\"/\\\"}"
  echo "$OUTPUT"
}

get_clip_str() {
  local STR

  STR=$(xclip -o)
  echo "$STR"
}

get_input_title() {
  local TITLE
  read -r -p "title(to abort 'q!'): " TITLE

  echo "$TITLE"
}

get_input_tags() {
  local TAGS 
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
  local BOOKMARKS_FILE=${4:-$HOME/.config/bookmarks/bookmarks.yaml}
  # YQ="/usr/bin/yq"
  local YQ="$HOME/.local/share/go/bin/yq"
  # "$YQ" -i '. + {"url": "'"$URL"'", "title": "'"$TITLE"'", "tags": [ "$TAGS" ]}' "$BOOKMARKS_FILE"
  "$YQ" '. + {"url": "'"$URL"'", "title": "'"$TITLE"'", "tags": [ '"$TAGS"' ]}' "$BOOKMARKS_FILE"
}

to_lowercase() {
  local STR=$1
  echo "${STR,,}"
}

trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
}

gen_tags_str() {
  local TAGS_STR=$1
  local TAGS_ARRAY
  local OUT_STR=""
  local TAG

  if [[ -z "$TAGS_STR" ]]; then 
    echo ""
  else
    TAGS_STR=$(trim "$TAGS_STR")
    # Remove front ,
    TAGS_STR=${TAGS_STR#,}
    # Remove tail ,
    TAGS_STR=${TAGS_STR%,}
    readarray -td, TAGS_ARRAY <<<"$TAGS_STR" # ; declare -p TAGS_ARRAY;

    for (( i=0; i<${#TAGS_ARRAY[@]}; i++ )); do
      TAG=$(trim "${TAGS_ARRAY[i]}")
      OUT_STR="$OUT_STR"", \"""${TAG}""\""
    done
    OUT_STR=${OUT_STR#, }
    echo "$OUT_STR"
  fi
}

gen_search_str() {
  local STR=$1
  jq --raw-input --raw-output @uri <<<"$STR"
}

check_tag() {
  local TITLE=$1
  local TAG=$2
  local BOOKMARKS_FILE=${3:-$HOME/.config/bookmarks/bookmarks.yaml}
  local YQ="$HOME/.local/share/go/bin/yq"

  local SEARCH_CONDITION=".[] | select(.title == \"""$TITLE""\" and .tags[] == \"""$TAG""\") | .url"

  local URL_QUOT
  URL_QUOT=$("$YQ" "$SEARCH_CONDITION" "$BOOKMARKS_FILE")
  local URL
  URL=$(remove_head_tail_chars "$URL_QUOT")

  [[ -z "$URL" ]] && echo "no" || echo "yes"
}

open_new_web_url() {
  local URL=$1

  local OPEN_INPUT="o"
  xdotool key Escape
  xdotool type "$OPEN_INPUT"
  sleep 0.2
  xdotool type "$URL"
  xdotool key Return
}
