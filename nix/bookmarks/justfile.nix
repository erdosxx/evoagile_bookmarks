{ inputs, cell }: {
  test = {
    description = "run bats test";
    content = ''
      bats tests
    '';
  };
  up = {
    description = "update flake";
    content = ''
      nix flake update
    '';
  };
  dev = {
    description = "devshell env";
    content = ''
      std //bookmarks/devshells/default:enter
    '';
  };
}
