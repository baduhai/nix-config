{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = "${lib.getExe pkgs.nix-your-shell} fish | source";
    loginShellInit = "${lib.getExe pkgs.nix-your-shell} fish | source";
    plugins = [
      {
        name = "bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "f969c618301163273d0a03d002614d9a81952c1e";
          sha256 = "sha256-A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "067e867debee59aee231e789fc4631f80fa5788e";
          sha256 = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
        };
      }
    ];
  };
}
