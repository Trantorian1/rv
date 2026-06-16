{lib, ...}: let
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
  options = {
    plugins = lib.mkOption {
      type = lib.types.listOf typePlugin;
      default = [];
    };

    shell = lib.mkOption {
      type = lib.types.package;
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
