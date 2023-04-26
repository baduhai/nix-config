{ inputs, config, pkgs, lib, ... }:

{
  security.unprivilegedUsernsClone = true; # Needed for rootless podman
}
