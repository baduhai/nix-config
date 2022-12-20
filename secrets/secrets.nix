let
  io = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCIrKJk5zWzWEHvLMPMK8T3PyeBjsCsqzxPN+OrXfhA";
  desktops = [ io ];
  
  alexandria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK95QueW+jp1ZmF299Xr3XkgHJ6dL7aZVsfWxqbOKVKA";
  servers = [ alexandria ];
in
{
  "cloudflare-creds.age".publicKeys = [ alexandria ];
}
