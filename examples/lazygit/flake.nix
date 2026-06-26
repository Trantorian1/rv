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
            # Adds new plugins to the config. A plugin consists of a config file and optionally
            # a vim package as well as a list of runtime dependencies.
            config.plugins = [
              {
                # The plugin to install
                package = pkgs.vimPlugins.lazygit-nvim;
                # The plugin configuration
                config = ./lazygit.lua;
                # Packages used by the plugin at runtime
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
