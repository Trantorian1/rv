{
  description = "Graphical neovim configuration for Rust development";

  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-26.05";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    rust-overlay,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        flake-parts.flakeModules.modules
        ./module
        ./test
        ./lib
        ./overlay.nix
        ./rv.nix
      ];

      flake.modules.flake.default = ./module;

      perSystem = {
        self',
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            self'.packages.nvim
            self'.packages.rv
            nurl
          ];
        };
      };
    };
}
