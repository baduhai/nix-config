{ ... }:

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
          "paperless"
          "vaultwarden"
        ];
      };
    };
  };
}
