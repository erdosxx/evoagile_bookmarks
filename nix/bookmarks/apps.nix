{ inputs, cell }:
let
  inherit (inputs) nixpkgs std;
  inherit (inputs) self;
  l = nixpkgs.lib // builtins;

  functions_lib =
    nixpkgs.callPackage (self + /src/functions_lib.nix) { inherit nixpkgs; };

  add_bookmark = nixpkgs.callPackage (self + /src/add_bookmark.nix) {
    inherit nixpkgs functions_lib;
  };

  find_bookmark = nixpkgs.callPackage (self + /src/find_bookmark.nix) {
    inherit nixpkgs functions_lib;
  };

  find_bookmark_by_tag =
    nixpkgs.callPackage (self + /src/find_bookmark_by_tag.nix) {
      inherit nixpkgs functions_lib;
    };

  add_command = nixpkgs.callPackage (self + /src/add_command.nix) {
    inherit nixpkgs functions_lib;
  };

  find_command = nixpkgs.callPackage (self + /src/find_command.nix) {
    inherit nixpkgs functions_lib;
  };

  find_command_by_tag =
    nixpkgs.callPackage (self + /src/find_command_by_tag.nix) {
      inherit nixpkgs functions_lib;
    };

  get_web_search = nixpkgs.callPackage (self + /src/gen_web_search.nix) {
    inherit nixpkgs functions_lib;
  };
in {
  default = nixpkgs.symlinkJoin {
    name = "evoagile_bookmarks";
    paths = [
      functions_lib
      add_bookmark
      find_bookmark
      find_bookmark_by_tag
      add_command
      find_command
      find_command_by_tag
      get_web_search
    ];
  };
}
