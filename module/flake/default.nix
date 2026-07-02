{...}: {
  imports = [./overlay.nix];

  perSystem = {...}: {
    imports = [
      ../options.nix
      ../config.nix
    ];
  };
}
