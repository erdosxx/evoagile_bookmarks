set shell := ["zsh", "-c"]

dev:
  nix develop

test:
  bats tests

up:
  nix flake update
