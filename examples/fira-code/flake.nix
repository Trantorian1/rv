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
                config = ./fira-code.lua;
              }
            ];
            config.fonts = with pkgs; [nerd-fonts.fira-code];
          }
        ];
      };
    in {
      nixosModules.default = module;
      packages.default = self.nixosModules.${system}.default.config.rv;
      apps.deefault = rv.util.mkApp self.packages.${system}.default;
    });
}
