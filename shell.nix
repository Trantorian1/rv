{
  system ? builtins.currentSystem,
  super ? import ./. {inherit system;},
  pkgs ? super.pkgs,
  ...
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    super.config.nvim
    super.config.rv
    npins
  ];
}
