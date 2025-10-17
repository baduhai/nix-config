let
  io-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io";
  io = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCIrKJk5zWzWEHvLMPMK8T3PyeBjsCsqzxPN+OrXfhA root@io";

  rotterdam-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam";
  rotterdam = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjXcqQqlu03x2VVTdWOyxtKRszXAKX0AxTkGvF1oeJL root@rotterdam";

  alexandria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK95QueW+jp1ZmF299Xr3XkgHJ6dL7aZVsfWxqbOKVKA root@alexandria";

  trantor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkGuGLZPnYJbCGY4BhJ9uTupp6ruuR1NZ7FEYEaLPA7 root@alexandria";
in

{
  "cloudflare.age".publicKeys = [
    io-user
    rotterdam-user
    alexandria
  ];
  "nextcloud-adminpass.age".publicKeys = [
    io-user
    rotterdam-user
    alexandria
  ];
  "nextcloud-secrets.json.age".publicKeys = [
    io-user
    rotterdam-user
    alexandria
  ];
}
