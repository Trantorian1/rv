{
  config,
  pkgs,
  ...
}: let
  rust_overlay = import ../rust-overlay.nix;

  nixpkgs = pkgs.extend rust_overlay.overlay;

  rust = rust_overlay.makeRustVersion {
    inherit (config.rv) rustVersion;
    inherit nixpkgs;
  };
in {
  _module.args.rust = rust;
}
