{ inputs, cell }:
let
  inherit (inputs) std nixpkgs self;
  # inherit (std.lib) cfg;
  inherit (cell) configs;
  inherit (std.lib.dev) mkShell;
  l = nixpkgs.lib // builtins;

  # pkgs = nixpkgs.legacyPackages.${system};

  bats-with-libraries = nixpkgs.symlinkJoin {
    name = "bats-with-libraries";
    paths = with nixpkgs; [
      bats
      bats.libraries.bats-support
      bats.libraries.bats-assert
      bats.libraries.bats-file
      bats.libraries.bats-detik
      just
      xdotool
      xclip
      jq
      yq-go
      bc
    ];
  };

  test-helper = nixpkgs.writeTextFile {
    name = "test_helper.bash";
    text = ''
      #!/usr/bin/env bash

      _common_setup() {
        load "${nixpkgs.bats.libraries.bats-support}/share/bats/bats-support/load.bash"
        load "${nixpkgs.bats.libraries.bats-assert}/share/bats/bats-assert/load.bash"
        load "${nixpkgs.bats.libraries.bats-file}/share/bats/bats-file/load.bash"
        load "${nixpkgs.bats.libraries.bats-detik}/share/bats/bats-detik/detik.bash"

        # get the containing directory of this file
        # use $BATS_TEST_FILENAME instead of ''${BASH_SOURCE[0]} or $0,
        # as those will point to the bats executable's location or the preprocessed file respectively
        PROJECT_ROOT="$( cd "$( ${nixpkgs.coreutils}/bin/dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
        # make executables in src/ visible to PATH
        PATH="$PROJECT_ROOT/src:$PATH"
      }
    '';
  };

  functions_lib =
    nixpkgs.callPackage (self + /src/functions_lib.nix) { inherit nixpkgs; };
in l.mapAttrs (_: mkShell) {
  default = { ... }: {
    name = "bookmarks devshell";

    imports = [ std.std.devshellProfiles.default ];

    # buildInputs = [ bats-with-libraries ];
    packages = [ bats-with-libraries ];

    nixago = with configs; [ conform lefthook treefmt ];

    commands = [
      {
        name = "vi";
        category = "ops";
        help = "vi alias to neovim";
        command = ''nvim "$@"'';
      }
      {
        name = "tests";
        category = "Testing";
        help = "test common library";
        command = "bats tests";
      }
    ];

    devshell.startup.setup_test_helper = {
      deps = [ ];
      text = ''
        mkdir -p tests/test_helper
        cp ${test-helper} tests/test_helper/common-setup.bash
        chmod 744 tests/test_helper/common-setup.bash
        echo "common-setup.bash has been created with exact library paths."
        cp ${functions_lib}/bin/functions_lib.sh src
        chmod 744 src/functions_lib.sh
      '';
    };
  };
}
