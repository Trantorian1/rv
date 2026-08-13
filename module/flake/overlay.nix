{inputs, ...}: {
  perSystem = {
    system,
    config,
    ...
  }: let
    rust_overlay = import ../rust-overlay.nix;

    nixpkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [rust_overlay.overlay];
    };

    rust = rust_overlay.makeRustVersion {
      inherit (config.rv) rustVersion;
      inherit nixpkgs;
    };
  in {
    _module.args.rust = rust;
  };
}
