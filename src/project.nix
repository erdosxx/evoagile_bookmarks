{ pkgs }:
let
  echo = "${pkgs.coreutils}/bin/echo";
  touch = "${pkgs.coreutils}/bin/touch";
in pkgs.writeShellScriptBin "project.sh" ''
  FIRST_RUN_FILE=/tmp/bats-tutorial-project-ran

  [[ ! -e "$FIRST_RUN_FILE" ]] && ${echo} "Welcome to our project!" && ${touch} "$FIRST_RUN_FILE"

  ${echo} "NOT IMPLEMENTED!" >&2
  exit 1
''
