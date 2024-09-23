{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  users = {
    users = {
      nginx.extraGroups = [ "acme" ];
    };
    groups = {
      hosted = {
        gid = 1005;
        members = [
          "user"
          "minecraft"
          "paperless"
          "vaultwarden"
        ];
      };
    };
  };
}
