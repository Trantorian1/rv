{
  lib,
  nvim,
  ...
}: {
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

  environment.systemPackages = [nvim];

  system.stateVersion = "26.05";
}
