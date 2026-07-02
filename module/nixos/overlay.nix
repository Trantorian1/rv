{
  config,
  pkgs,
  ...
}: let
  nixpkgs = pkgs.extend (import ../rust-overlay.nix);
in {
  _module.args.rust = nixpkgs.rust-bin.stable.${config.rv.rustVersion}.default.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
    ];
    targets = [
      "wasm32-unknown-unknown"
    ];
  };
}
