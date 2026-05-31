{
  config,
  lib,
  inputs,
  ...
}:

{
  users.users.gitea-runner = {
    isSystemUser = true;
    group = "gitea-runner";
  };

  users.groups.gitea-runner = { };

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
    DynamicUser = lib.mkForce false;
    User = "gitea-runner";
    Group = "gitea-runner";
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };
}
