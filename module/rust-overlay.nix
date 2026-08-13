{
  overlay = import (builtins.fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/e3fa5cf86b93914b8f312b2a1ca14fbb139c655c.tar.gz";
    sha256 = "sha256:04ci7amdr6xxdd802dv0i2csvwlqyj603w9kv40r7jn343vqmihy";
  });

  makeRustVersion = {
    rustVersion,
    nixpkgs,
  }: let
    lib = nixpkgs.lib;

    extensions = [
      "rust-src"
      "rust-analyzer"
    ];
    targets = [
      "wasm32-unknown-unknown"
    ];
  in
    if lib.strings.hasPrefix "nightly:" rustVersion
    then
      nixpkgs.rust-bin.nightly.${lib.strings.removePrefix "nightly:" rustVersion}.default.override {
        inherit extensions targets;
      }
    else if lib.strings.hasPrefix "nightly" rustVersion
    then
      nixpkgs.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          inherit extensions targets;
        })
    else
      nixpkgs.rust-bin.stable.${rustVersion}.default.override {
        inherit extensions targets;
      };
}
