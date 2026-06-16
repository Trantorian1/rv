{
  rv ? import ../default.nix {},
  pkgs ? rv.pkgs,
  ...
}: let
  module = rv.module.extendModules {
    modules = [
      {
        config.shell = pkgs.bash;
      }
    ];
  };
in {
  inherit module;
}
