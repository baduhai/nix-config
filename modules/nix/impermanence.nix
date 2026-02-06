{ inputs, ... }:

{
  flake-file.inputs = {
    impermanence.url = "github:nix-community/impermanence";
  };

  # convenience function to set persistence settings only, if impermanence module was imported
  flake.lib = {
    mkIfPersistence =
      config: settings:
      if config ? home then
        (if config.home ? persistence then settings else { })
      else
        (if config.environment ? persistence then settings else { });
  };

  flake.modules.nixos.impermanence =
    { config, ... }:
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      environment.persistence."/persistent" = {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };

      # home-manager.sharedModules = [
      #   {
      #     home.persistence."/persistent" = {
      #     };
      #   }
      # ];

      fileSystems."/persistent".neededForBoot = true;

      programs.fuse.userAllowOther = true;
    };

}
