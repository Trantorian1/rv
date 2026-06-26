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
                # You can set just the config file if all you want to do is add some custom lua to
                # your neovim configuration.
                config = ./fira-code.lua;
              }
            ];

            # List of gui fonts to be used at runtime by neovide
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
