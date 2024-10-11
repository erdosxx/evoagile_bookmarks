{ nixpkgs, functions_lib}:
let
in nixpkgs.writeShellScriptBin "find_command.sh" ''
  source ${functions_lib}/bin/functions_lib.sh
  
  main() {
    local BOOKMARKS_FILE=''${1:-$HOME/.config/bookmarks/commands.yaml}
  
    local TITLE_LIST
    TITLE_LIST=$(get_title_list "$BOOKMARKS_FILE")
    local TITLE
    TITLE="$(make_dmenu_selection "$TITLE_LIST")"
  
    [[ -z "$TITLE" ]] && exit 0
  
    local TITLE_QUOT_FIX
    TITLE_QUOT_FIX="$(add_two_back_slashes "$TITLE")"
  
    local CMD
    CMD="$(find_url_by_title "$TITLE_QUOT_FIX" "$BOOKMARKS_FILE")"
  
    # xdotool type "$CMD"
    command_paste "$CMD"
  }
  
  main "$1"
''
