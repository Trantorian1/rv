{inputs, ...}: {
  perSystem = {
    system,
    config,
    pkgs,
    ...
  }: let
    rust-overlay = import (pkgs.fetchFromGitHub {
      owner = "oxalica";
      repo = "rust-overlay";
      rev = "5106a604b3d67cffe8eb51a8bd9f04e607f0d31d";
      hash = "sha256-WJPfr9EAWVIuTMyb/ilHKUYlg/RNa0xrNiWR+p1iHUg=";
    });

    nixpkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [rust-overlay];
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
