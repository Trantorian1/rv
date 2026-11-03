{
  description = "Graphical neovim configuration for Rust development";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    opencode-sandbox.url = "github:OpencodeSandbox/opencode-sandbox?ref=feat/opencodev2";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    opencode-sandbox,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./module/flake.nix
        ./test
        ./lib
        ./rv.nix

        flake-parts.flakeModules.modules
      ];

      flake.modules.flake.default = ./module/flake.nix;
      flake.nixosModules.default = ./module/nixos.nix;

      perSystem = {
        self',
        pkgs,
        system,
        ...
      }: {
        packages = {
          sandbox = opencode-sandbox.packages.${system}.sandbox.override {
            opencode-sandbox = {
              git.remote.url = "https://github.com/Trantorian1/rv.git";
              git.shutdown.pushOnExit = false;
              git.withLocalChanges = true;

              opencode.config.mountHomeConfig = true;
              forwardPorts = [8888];

              env.extend = with pkgs; [
                # nix
                nil
                alejandra

                # lua
                lua-language-server
                stylua

                # shared dev env
                self'.packages.devenv
              ];
            };
          };

          devenv = pkgs.buildEnv {
            name = "devenv";
            paths = with pkgs; [nurl];
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          packages = [self'.packages.devenv];
        };
      };
    };
}
