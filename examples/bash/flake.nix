{
  inputs.rv.url = ../../.;

  outputs = {
    self,
    rv,
    ...
  }:
    rv.util.eachDefaultSystem (system: let
      pkgs = rv.packages.${system}.pkgs;

      # rv configuration options are exposed in the root flake as `nixosModules`: you can use
      # `extendModules` to customize this with your own behavior.
      module = rv.nixosModules.${system}.rv.extendModules {
        modules = [
          {
            # Overrides the default shell
            config.shell = pkgs.bash;
          }
        ];
      };
    in {
      nixosModules.default = module;
      packages.default = self.nixosModules.${system}.default.config.rv;
      apps.default = rv.util.mkApp self.packages.${system}.default;
    });
}
