{
  description = "Graphical neovim configuration for Rust development";

  outputs = {self, ...}: let
    util = import ./lib/util.nix {};
  in
    util.eachDefaultSystem (
      system: let
        super = import ./. {inherit system;};
        shell = import ./shell.nix {inherit system;};
      in {
        formatter = super.pkgs.alejandra;

        packages = rec {
          rv = super.module.config.rv;
          nvim = super.module.config.nvim;
          iso = super.module.config.iso;
          vm = super.module.config.vm;
          test = super.module.config.test;

          default = rv;
        };
        apps = rec {
          rv = util.mkApp self.packages.${system}.rv;
          nvim = util.mkApp self.packages.${system}.nvim;
          vm = util.mkApp self.packages.${system}.vm;

          default = rv;
        };
        checks = {
          nvim = self.packages.${system}.test;
        };
        devShells = rec {
          rv = shell;

          default = rv;
        };
      }
    );
}
