{
  pkgs,
  lib,
  ...
}: let
  typePlugin = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
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
  options.rv = {
    plugins = lib.mkOption {
      type = lib.types.listOf typePlugin;
      default = [];
    };

    rustVersion = lib.mkOption {
      type = lib.types.str;
      default = "1.96.0";
    };

    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fish;
    };

    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };

    nvim = lib.mkOption {
      type = lib.types.package;
    };

    editor = lib.mkOption {
      type = lib.types.package;
    };
  };
}
