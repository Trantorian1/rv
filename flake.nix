{
  description = "Graphical neovim configuration for Rust development";

  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.util.url = ./lib;

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    util,
    ...
  }:
    util.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlays.default];
        };

        rustVersion =
          if builtins.pathExists ./rust-toolchain.toml
          then (pkgs.lib.trivial.importToml ./rust-toolchain.toml).toolchain.channel
          else "1.96.0";

        rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
          targets = [
            "wasm32-unknown-unknown"
          ];
        };

        module = pkgs.lib.evalModules {
          specialArgs = {inherit pkgs rust;};
          modules = [
            ./options.nix
            ./config.nix
          ];
        };
      in {
        formatter = pkgs.alejandra;

        nixosModules = rec {
          rv = module;

          default = rv;
        };

        packages = rec {
          inherit pkgs rust;

          rv = self.nixosModules.${system}.rv.config.rv;
          nvim = self.nixosModules.${system}.rv.config.nvim;

          default = rv;
        };

        apps = rec {
          rv = util.mkApp self.packages.${system}.rv;
          nvim = util.mkApp self.packages.${system}.nvim;

          default = rv;
        };

        checks = {
          nvim = pkgs.callPackage ./test/nvim.nix {
            nvim = self.packages.${system}.nvim;
          };
        };

        devShells = rec {
          rv = pkgs.mkShellNoCC {
            packages = [
              self.packages.${system}.nvim
              self.packages.${system}.rv
            ];
          };

          default = rv;
        };
      }
    );
}
