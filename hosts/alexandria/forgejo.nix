{ ... }:

{
  services.forgejo = {
    enable = true;
    repositoryRoot = "/data/forgejo";
    settings = {
      session.COOKIE_SECURE = true;
      server = {
        PROTOCOL = "http+unix";
        DOMAIN = "git.baduhai.dev";
        ROOT_URL = "https://git.baduhai.dev";
        OFFLINE_MODE = true; # disable use of CDNs
        SSH_DOMAIN = "baduhai.dev";
      };
      log.LEVEL = "Warn";
      mailer.ENABLED = false;
      actions.ENABLED = false;
    };
  };
}
