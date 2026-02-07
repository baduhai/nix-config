{ ... }:
{
  flake.modules.nixos.libvirtd = { config, lib, pkgs, ... }: {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = true;

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    users.users.user.extraGroups = [
      "libvirt"
      "libvirtd"
    ];
  };
}
