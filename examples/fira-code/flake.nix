{
  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-26.05";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    rv = {
      url = ../../.;
    };
  };

  outputs = inputs @ {
    flake-parts,
    rv,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # `rv` configuration options are exposed as a default flake module which you need to import
      imports = [rv.modules.flake.default];
      systems = ["x86_64-linux"];

      perSystem = {
        self',
        pkgs,
        config,
        ...
      }: {
        # `rv` configuration options are available under `config.rv`, which we set here, adding some
        # additional lua logic and importing a custom font
        rv.plugins = [{config = ./fira-code.lua;}];
        rv.fonts = [pkgs.nerd-fonts.fira-code];

        # `rv` exposes several configuration options, each defined in `module/options.nix`, but the
        # most important for your purpose are `nvim` and `editor` which contain its terminal and
        # graphical-based capabilities
        packages.default = config.rv.editor;
        apps.default = rv.lib.mkApp self'.packages.default;
      };
    };
}
