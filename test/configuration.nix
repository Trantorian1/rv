{
  pkgs,
  lib,
  ...
}: let
  super = import ../. {inherit (pkgs.stdenv.hostPlatform) system;};
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = lib.mkForce 5;

  boot.kernelParams = ["console=ttyS0,115200"];

  users.users.alice = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "test";
  };

  services.getty.autologinUser = "alice";

  environment.systemPackages = [super.config.nvim];

  system.stateVersion = "26.05";
}
