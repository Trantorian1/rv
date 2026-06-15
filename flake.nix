{
  description = "Graphical neovim configuration for Rust development";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      module = import ./. {inherit system;};
      shell = import ./shell.nix {inherit system;};
    in {
      packages = rec {
        rv = module.config.rv;
        nvim = module.config.nvim;
        default = rv;
      };
      apps = rec {
        rv = flake-utils.lib.mkApp {drv = self.packages.${system}.rv;};
        nvim = flake-utils.lib.mkApp {drv = self.packages.${system}.nvim;};
        default = rv;
      };
      devShells = rec {
        rv = shell;
        default = rv;
      };
    });
}
