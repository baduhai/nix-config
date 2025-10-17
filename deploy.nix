{ inputs, self, ... }:
{
  flake.deploy = {
    remoteBuild = true;
    nodes = {
      alexandria = {
      hostname = "alexandria";
      profiles.system = {
        sshUser = "user";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.alexandria;
        user = "root";
      };
    };

    trantor = {
      hostname = "trantor";
      profiles.system = {
        sshUser = "user";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.trantor;
        user = "root";
      };
    };

    io = {
      hostname = "io";
      profiles = {
        system = {
          sshUser = "user";
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
};
  perSystem =
    { system, ... }:
    {
      checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
    };
}
