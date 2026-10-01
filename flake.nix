{
  description = "Graphical neovim configuration for Rust development";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";

    opencode-sandbox.url = "github:trantorian1/opencode-sandbox";
    opencode-sandbox.inputs.nixpkgs.follows = "nixpkgs";
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
              forwardPorts = [8888];
              extraEnv = with pkgs; [
                # nix
                nixd
                alejandra

                # lua
                lua-language-server
                stylua
              ];
            };
          };

          devenv = pkgs.buildEnv {
            name = "devenv";
            paths = with pkgs; [
              nurl
            ];
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          packages = [self'.packages.devenv];
        };
      };
    };
}
