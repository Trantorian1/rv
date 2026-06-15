{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ?
    import sources.nixpkgs {
      inherit system;
      config = {};
      overlays = [(import sources.rust-overlay)];
    },
  rustVersion ?
    if builtins.pathExists ./rust-toolchain.toml
    then let
      toolchain = pkgs.lib.trivial.importTOML ./rust-toolchain.toml;
    in
      toolchain.toolchain.channel
    else "1.96.0",
  rustRelease ?
    pkgs.rust-bin.stable.${rustVersion}.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
      targets = [
        "wasm32-unknown-unknown"
      ];
    },
}
: let
  modules = pkgs.lib.evalModules {
    modules = [
      ({config, ...}: {config._module.args = {inherit pkgs rustRelease;};})
      ./nvim.nix
    ];
  };
in {
  inherit pkgs;
  inherit (modules) config;
}
