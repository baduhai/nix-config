{
  config,
  lib,
  inputs,
  ...
}:

{
  services.gitea-actions-runner.instances.trantor = {
    enable = true;
    name = "trantor";
    url = "https://git.baduhai.dev";
    tokenFile = config.age.secrets.forgejo-runner-token.path;
    labels = [
      "ubuntu-latest:docker://node:20-bookworm"
      "debian-latest:docker://node:20-bookworm"
    ];
    settings = {
      runner = {
        timeout = "3h";
      };
    };
  };

  age.secrets.forgejo-runner-token = {
    file = "${inputs.self}/secrets/forgejo-runner-token.age";
  };

  environment.persistence.main.directories = [
    {
      directory = "/var/lib/gitea-runner";
      user = "gitea-runner";
      group = "gitea-runner";
      mode = "0700";
    }
  ];

  systemd.services."gitea-runner-trantor".serviceConfig = {
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };
}
