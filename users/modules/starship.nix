{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = ''
        $hostname$directory$git_branch$git_status$nix_shell
        [ ❯ ](bold green)
      '';
      right_format = "$cmd_duration$character";
      hostname = {
        ssh_symbol = "󰖟 ";
      };
      character = {
        error_symbol = "[](red)";
        success_symbol = "[󱐋](green)";
      };
      cmd_duration = {
        format = "[󰄉 $duration ]($style)";
        style = "yellow";
        min_time = 500;
      };
      git_branch = {
        symbol = " ";
        style = "purple";
      };
      git_status.style = "red";
      nix_shell = {
        format = "via [$symbol$state]($style)";
        heuristic = true;
        style = "blue";
        symbol = "󱄅 ";
      };
    };
  };
}
