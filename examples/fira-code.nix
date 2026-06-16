{
  rv ? import ../default.nix {},
  pkgs ? rv.pkgs,
  ...
}: let
  module = rv.module.extendModules {
    modules = [
      {
        config.plugins = [
          {
            config = ./fira-code.lua;
          }
        ];
        config.fonts = with pkgs; [nerd-fonts.fira-code];
      }
    ];
  };
in {
  inherit module;
}
