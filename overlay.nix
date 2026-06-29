{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = builtins.break import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.rust-overlay.overlays.default];
    };

    rustVersion =
      if builtins.pathExists ./rust-toolchain.toml
      then (pkgs.lib.trivial.importToml ./rust-toolchain.toml).toolchain.channel
      else "1.96.0";

    rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
      targets = [
        "wasm32-unknown-unknown"
      ];
    };
  in {
    _module.args = {inherit pkgs rust;};
  };
}
