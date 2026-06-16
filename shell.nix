{
  system ? builtins.currentSystem,
  rv ? import ./. {inherit system;},
  pkgs ? rv.pkgs,
  ...
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    rv.module.config.nvim
    rv.module.config.rv
    npins
  ];
}
