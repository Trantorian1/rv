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
          rv = super.config.rv;
          nvim = super.config.nvim;
          iso = super.config.iso;
          vm = super.config.vm;
          test = super.config.test;

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
