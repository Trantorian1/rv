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
            package = pkgs.vimPlugins.lazygit-nvim;
            config = ./lazygit.lua;
            runtimeDeps = with pkgs; [lazygit];
          }
        ];
      }
    ];
  };
in {
  inherit module;
}
