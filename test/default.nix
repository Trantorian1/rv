{self, ...}: {
  flake.nixosModules.forTesting = {
    imports = [
      ./configuration.nix
      self.nixosModules.default
    ];
  };

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    checks.nvim = pkgs.testers.runNixOSTest {
      name = "test-config";

      node.specialArgs.nvim = config.packages.nvim;
      nodes.machine = self.nixosModules.forTesting;

      testScript = ''
        machine.wait_for_unit("default.target")
        machine.succeed("su -- alice -c 'which nvim'")

        with subtest("Load config"):
          output = machine.succeed("su -- alice -c 'nvim --headless +qa' 2>&1")
          assert output.strip() == "", "nvim encountered errors on startup: \n" + output
      '';
    };
  };
}
