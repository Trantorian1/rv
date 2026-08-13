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
        # `rv` configuration options are available under `config.rv`. Beyond extending rv with new
        # plugins and their configuration, you can also add extra runtime dependencies you might
        # need in your Rust projects. Here we add `cargo-generate`, which you can use to initialize
        # new projects from existing templates.
        rv.runtimeDeps = with pkgs; [cargo-generate];

        # `rv` exposes several configuration options, each defined in `module/options.nix`, but the
        # most important for your purpose are `nvim` and `editor` which contain its terminal and
        # graphical-based capabilities
        packages.default = config.rv.editor;
        apps.default = rv.lib.mkApp self'.packages.default;
      };
    };
}
