{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "William";
        email = "baduhai@proton.me";
      };
    };
    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
