{
  super ? import ./. {},
  pkgs ? super.pkgs,
  ...
}: {
  shell = pkgs.mkShellNoCC {
    packages = with pkgs; [
      super.config.nvim
      super.config.rv
      npins
    ];
  };
}
