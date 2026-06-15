{
  pkgs,
  lib,
  ...
}: let
  typePlugin = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
      };
      config = lib.mkOption {
        type = lib.types.path;
      };
      runtimeDeps = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
      };
    };
  };
in {
  options = {
    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
    };

    plugins = lib.mkOption {
      type = lib.types.listOf typePlugin;
      default = [];
    };

    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };

    nvim = lib.mkOption {
      type = lib.types.package;
    };

    rv = lib.mkOption {
      type = lib.types.package;
    };
  };
}
