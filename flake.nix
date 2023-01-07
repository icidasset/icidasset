{
  description = "icidasset";


  # Inputs
  # ======

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };


  # Outputs
  # =======

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "icidasset";
      shell = ./nix/shell.nix;
    };
}