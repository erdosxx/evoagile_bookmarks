{ inputs, cell }:
let
  pkgs = inputs.nixpkgs;
  inherit (inputs.std.lib) cfg;
  inherit (inputs.std.lib.dev) mkNixago;
  # l = nixpkgs.lib // builtins;

in {
  conform = (mkNixago cfg.conform) {
    data = {
      commit = {
        header = { length = 89; };
        conventional = {
          types = [
            "build"
            "chore"
            "ci"
            "docs"
            "feat"
            "fix"
            "perf"
            "refactor"
            "style"
            "test"
          ];
        };
      };
    };
  };
  lefthook = (mkNixago cfg.lefthook) {
    data = {
      commit-msg = {
        commands = {
          conform = {
            run = "${pkgs.conform}/bin/conform enforce --commit-msg-file {1}";
          };
        };
      };
      pre-commit = {
        commands = {
          treefmt = { run = "${pkgs.treefmt}/bin/treefmt {staged_files}"; };
        };
      };
    };
    packages = [ pkgs.lefthook ];
  };
  treefmt = (mkNixago cfg.treefmt) {
    data = {
      formatter = {
        nix = {
          command = "nixpkgs-fmt";
          includes = [ "*.nix" ];
        };
      };
    };
    packages = with pkgs; [ nixpkgs-fmt ];
  };

  just = (mkNixago cfg.just) {
    data.tasks = import ./justfile.nix { inherit inputs cell; };
  };
}
