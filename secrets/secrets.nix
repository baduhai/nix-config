let
  io = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCIrKJk5zWzWEHvLMPMK8T3PyeBjsCsqzxPN+OrXfhA";
  rotterdam = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL"
  desktops = [ io rotterdam ];

  alexandria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK95QueW+jp1ZmF299Xr3XkgHJ6dL7aZVsfWxqbOKVKA";
  servers = [ alexandria ];

  all-hosts = desktops ++ servers;
in
{
  "cloudflare-creds.age".publicKeys = all-hosts;
  "paperless-pass.age".publicKeys = all-hosts;
}
