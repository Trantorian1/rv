# Modified in-tree version of https://github.com/nix-community/rustowl-flake
{
  pkgs,
  lib,
  rustowl-src,
  ...
}: let
  rust-overlay = import (builtins.fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/d1e30fd696e1151603aa8adaa8f6b8c604fe3eb0.tar.gz";
    sha256 = "sha256-KBjfmgZIUqBpjsemRKp4GvrCf8DlNsldkmxphh4X9oo=";
  });

  pkgs-rust = pkgs.extend rust-overlay;

  toolchain = pkgs-rust.rust-bin.fromRustupToolchainFile "${rustowl-src}/rust-toolchain.toml";
  toolchainTOML = lib.importTOML "${rustowl-src}/rust-toolchain.toml";
  cargoTOML = lib.importTOML "${rustowl-src}/Cargo.toml";
  rustPlatform = pkgs-rust.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "rustowl";
    version = "${cargoTOML.workspace.package.version}-unstable";

    src = rustowl-src;

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = with pkgs-rust; [
      toolchain
      pkg-config
    ];

    preCheck = ''
      # This test is impure
      rm crates/rustowl/tests/algorithm.rs
    '';

    buildInputs = with pkgs-rust;
      [
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        zlib
      ];

    RUSTOWL_TOOLCHAIN = toolchainTOML.toolchain.channel;
    RUSTOWL_SYSROOTS = "${toolchain}";
    RUSTUP_TOOLCHAIN = "${toolchain.version}";
    postInstall = ''
      install -Dm755 \
        $out/bin/rustowlc \
        $out/bin/sysroot/${RUSTOWL_TOOLCHAIN}/bin/rustowlc
    '';
    postFixup = ''
      # prevent rustowl from falling back to a downloaded toolchain
      ln -sfn ${RUSTOWL_SYSROOTS} $out/bin/sysroot/${RUSTUP_TOOLCHAIN}
    '';
    meta = with lib; {
      description = "Visualize ownership and lifetimes in Rust for debugging and optimization";
      longDescription = ''
        RustOwl visualizes ownership movement and lifetimes of variables.
        When you save Rust source code, it is analyzed, and the ownership and
        lifetimes of variables are visualized when you hover over a variable or function call.
      '';
      homepage = "https://github.com/cordx56/rustowl";
      license = licenses.mpl20;
      maintainers = [lib.maintainers.mrcjkb];
      platforms = platforms.all;
      mainProgram = "cargo-owlsp";
    };
  }
