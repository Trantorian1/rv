{
  description = "Graphical neovim configuration for Rust development";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      super = import ./. {inherit system;};
      shell = import ./shell.nix {inherit system;};
    in {
      packages = rec {
        rv = super.config.rv;
        nvim = super.config.nvim;
        iso = super.config.iso;
        vm = super.config.vm;
        test = super.config.test;

        default = rv;
      };
      apps = rec {
        rv = flake-utils.lib.mkApp {drv = self.packages.${system}.rv;};
        nvim = flake-utils.lib.mkApp {drv = self.packages.${system}.nvim;};
        vm = flake-utils.lib.mkApp {drv = self.packages.${system}.vm;};

        default = rv;
      };
      checks = {
        nvim = self.packages.${system}.test;
      };
      devShells = rec {
        rv = shell;

        default = rv;
      };
    });
}
