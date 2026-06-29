{self, ...}: {
  perSystem = {
    self',
    inputs',
    config,
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;

    packages = rec {
      inherit (config) nvim rv;

      default = rv;
    };

    apps = rec {
      nvim = self.lib.mkApp self'.packages.nvim;
      rv = self.lib.mkApp self'.packages.rv;

      default = rv;
    };
  };
}
