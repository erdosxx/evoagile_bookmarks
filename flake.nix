{
  description = "Bats testing environment with libraries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        bats-with-libraries = pkgs.symlinkJoin {
          name = "bats-with-libraries";
          paths = with pkgs; [
            bats
            bats.libraries.bats-support
            bats.libraries.bats-assert
            bats.libraries.bats-file
            bats.libraries.bats-detik
            just
            xdotool
            xclip
            jq
            yq
            bc
          ];
        };

        test-helper = pkgs.writeTextFile {
          name = "test_helper.bash";
          text = ''
            #!/usr/bin/env bash

            _common_setup() {
              load "${pkgs.bats.libraries.bats-support}/share/bats/bats-support/load.bash"
              load "${pkgs.bats.libraries.bats-assert}/share/bats/bats-assert/load.bash"
              load "${pkgs.bats.libraries.bats-file}/share/bats/bats-file/load.bash"
              load "${pkgs.bats.libraries.bats-detik}/share/bats/bats-detik/detik.bash"

              # get the containing directory of this file
              # use $BATS_TEST_FILENAME instead of ''${BASH_SOURCE[0]} or $0,
              # as those will point to the bats executable's location or the preprocessed file respectively
              PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
              # make executables in src/ visible to PATH
              PATH="$PROJECT_ROOT/src:$PATH"
            }
          '';
        };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ bats-with-libraries ];

          shellHook = ''
            mkdir -p tests/test_helper
            cp ${test-helper} tests/test_helper/common-setup.bash
            chmod +x tests/test_helper/common-setup.bash
            echo "common-setup.bash has been created with exact library paths."
            alias vi="nvim"
          '';
        };
      });
}
