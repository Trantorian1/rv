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
      inherit (config.rv) nvim editor;

      default = editor;
    };

    apps = rec {
      nvim = self.lib.mkApp self'.packages.nvim;
      editor = self.lib.mkApp self'.packages.editor;

      default = editor;
    };
  };
}
