{
  inputs.rv.url = ../../.;
  inputs.util.url = ../../lib;

  outputs = {
    self,
    rv,
    util,
    ...
  }:
    util.eachDefaultSystem (system: let
      pkgs = rv.packages.${system}.pkgs;
      module = rv.nixosModules.${system}.rv.extendModules {
        modules = [
          {
            config.shell = pkgs.bash;
          }
        ];
      };
    in {
      nixosModules.default = module;
      packages.default = self.nixosModules.${system}.default.config.rv;
      apps.default = util.mkApp self.packages.${system}.default;
    });
}
