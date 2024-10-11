{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    std = {
      url = "github:divnix/std";
      inputs = {
        devshell = {
          url = "github:numtide/devshell";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        nixago = {
          url = "github:nix-community/nixago";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { std, ... }@inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (runnables "apps")
        (devshells "devshells")
        # (functions "toolchain")
        (nixago "configs")
      ];
    } {
      packages = std.harvest inputs.self [[ "bookmarks" "apps" ]];
      devShells = std.harvest inputs.self [ "bookmarks" "devshells" ];
    };
}
