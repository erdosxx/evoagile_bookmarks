{ nixpkgs, functions_lib }:
let
  echo = "${nixpkgs.coreutils}/bin/echo";
  sleep = "${nixpkgs.coreutils}/bin/sleep";
in nixpkgs.writeShellScriptBin "add_command.sh" ''
  source ${functions_lib}/bin/functions_lib.sh

  main() {
    local CMD_INPUT
    local CMD
    local TITLE
    local TAGS
    local TAGS_STR
    local CMD_FILE=''${1:-$HOME/.config/bookmarks/commands.yaml}
    local CMD_BAK_FILE=''${2:-$HOME/.config/bookmarks/commands.yaml.bak}

    CMD="$(get_clip_str)"
    ${echo} "CMD: $CMD"

    if [[ $(check_double_quote "$CMD") -ne "0" ]]; then
      # ''${echo} "The CMD contains " character. Use '\'''' instead.'
      ${echo} 'The CMD contains double quote character. Use single quote instead.'
      ${sleep} 2
      exit
    fi

    if [[ $(get_num_url "$CMD" "$CMD_FILE") -ne "0" ]]; then
      ${echo} "The CMD is already exist in commands file."
      ${sleep} 2
      exit
    fi

    TITLE="$(get_input_title)"
    [[ "$TITLE" == "q!" ]] && exit

    while [[ $(get_num_title "$TITLE" "$CMD_FILE") -ne "0" ]]; do
      ${echo} "The title is already used. Try to use other title."
      TITLE=$(get_input_title)
    done

    ${echo} "Add tags with , delimiter, for example, three tags => abc, de & fg, hi"
    TAGS="$(get_input_tags)"
    TAGS_STR=$(gen_tags_str "$TAGS")

    backup_file "$CMD_FILE" "$CMD_BAK_FILE"

    add_new_entry "$CMD" "$TITLE" "$TAGS_STR" "$CMD_BAK_FILE" >"$CMD_FILE"
  }

  main "$1" "$2"
''
