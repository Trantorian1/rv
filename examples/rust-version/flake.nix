{
  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-26.05";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    rv = {
      url = "github:trantorian1/rv";
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
        # `rv` configuration options are available under `config.rv`. You can use this to set the
        # Rust version in use to any stable release.
        rv.rustVersion = "1.94.0";

        # Alternatively, you can defer to the default nightly release.
        #
        # rv.rustVersion = "nightly";

        # You can also request specific nightly versions by appending their release date.
        #
        # rv.rustVersion = "nightly:2026-07-01";

        # `rv` exposes several configuration options, each defined in `module/options.nix`, but the
        # most important for your purpose are `nvim` and `editor` which contain its terminal and
        # graphical-based capabilities
        packages.default = config.rv.editor;
        apps.default = rv.lib.mkApp self'.packages.default;
      };
    };
}
