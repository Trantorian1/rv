{inputs, ...}: {
  perSystem = {
    system,
    config,
    ...
  }: let
    nixpkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [(import ../rust-overlay.nix)];
    };

    rust = nixpkgs.rust-bin.stable.${config.rv.rustVersion}.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
      targets = [
        "wasm32-unknown-unknown"
      ];
    };
  in {
    _module.args.rust = rust;
  };
}
