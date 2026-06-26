{
  inputs.rv.url = ../../.;

  outputs = {
    self,
    rv,
    ...
  }:
    rv.util.eachDefaultSystem (system: let
      pkgs = rv.packages.${system}.pkgs;
      module = rv.nixosModules.${system}.rv.extendModules {
        modules = [
          {
            config.plugins = [
              {
                package = pkgs.vimPlugins.lazygit-nvim;
                config = ./lazygit.lua;
                runtimeDeps = [pkgs.lazygit];
              }
            ];
          }
        ];
      };
    in {
      nixosModules.default = module;
      packages.default = self.nixosModules.${system}.default.config.rv;
      apps.default = rv.util.mkApp self.packages.${system}.default;
    });
}
