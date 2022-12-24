{ inputs, config, pkgs, libs, ... }:

{
  system.activationScripts.shiori.text = ''
    mkdir -p /data/shiori
    chown shiori:hosted /data/shiori
    ln -sfn /var/lib/shiori/* /data/shiori/
  '';
}
