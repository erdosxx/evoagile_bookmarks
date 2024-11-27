{ nixpkgs, functions_lib }:
let
  echo = "${nixpkgs.coreutils}/bin/echo";
  sleep = "${nixpkgs.coreutils}/bin/sleep";
in
nixpkgs.writeShellScriptBin "add_bookmark.sh" ''
  source ${functions_lib}/bin/functions_lib.sh

  main() {
    local URL_INPUT
    local URL
    local TITLE
    local TAGS
    local TAGS_STR
    local BOOKMARKS_FILE=''${1:-$HOME/.config/bookmarks/bookmarks.yaml}
    local BOOKMARKS_BAK_FILE=''${2:-$HOME/.config/bookmarks/bookmarks.yaml.bak}

    URL_INPUT="$(get_clip_str)"
    ${echo} "URL: $URL_INPUT"

    URL=$(rm_tail_slash "$URL_INPUT")

    if [[ $(get_num_url "$URL" "$BOOKMARKS_FILE") -ne "0" ]]; then
      ${echo} "The URL is already exist in bookmark."
      ${sleep} 2
      exit
    fi

    TITLE="$(get_input_title)"
    [[ "$TITLE" == "q!" ]] && exit

    while [[ $(get_num_title "$TITLE" "$BOOKMARKS_FILE") -ne "0" ]]; do
      ${echo} "The title is already used. Try to use other title."
      TITLE=$(get_input_title)
    done

    ${echo} "Add tags with , delimiter, for example, three tags => abc, de & fg, hi"
    TAGS="$(get_input_tags)"
    TAGS_STR=$(gen_tags_str "$TAGS")

    backup_file "$BOOKMARKS_FILE" "$BOOKMARKS_BAK_FILE"

    # echo "$(add_new_bookmark "$URL" "$TITLE" "$TAGS_STR" "$BOOKMARKS_BAK_FILE")" > "$BOOKMARKS_FILE"
    add_new_entry "$URL" "$TITLE" "$TAGS_STR" "$BOOKMARKS_BAK_FILE" >"$BOOKMARKS_FILE"
  }

  main "$1" "$2"
''
