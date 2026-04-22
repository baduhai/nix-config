{
  config,
  lib,
  inputs,
  ...
}:

{
  services.pocket-id = {
    enable = true;
    environmentFile = config.age.secrets.pocket-id-key.path;
    settings = {
      APP_URL = "https://auth.baduhai.dev";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
    };
  };

  age.secrets.pocket-id-key = {
    file = "${inputs.self}/secrets/pocket-id.key.age";
  };
}
