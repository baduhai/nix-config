{ inputs, self, ... }:
{
  flake.deploy.nodes = {
    alexandria = {
      hostname = "alexandria";
      profiles.system = {
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.alexandria;
        user = "root";
      };
    };

    trantor = {
      hostname = "trantor";
      profiles.system = {
        sshUser = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.trantor;
        user = "root";
      };
    };

    io = {
      hostname = "io";
      profiles = {
        system = {
          sshUser = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.io;
          user = "root";
        };
        user = {
          sshUser = "user";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations."user@io";
          user = "user";
        };
      };
    };
  };

  # Optional: Add deploy-rs checks
  flake.checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
}
