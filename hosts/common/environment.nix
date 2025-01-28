{ pkgs, ... }:

{
  environment.shellAliases = {
    ls = "${pkgs.eza}/bin/eza --icons --group-directories-first";
    neofetch = "fastfetch";
    tree = "ls --tree";
    syscleanup = "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
  };
}
