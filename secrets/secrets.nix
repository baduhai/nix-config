let
  io-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs";
  io-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCIrKJk5zWzWEHvLMPMK8T3PyeBjsCsqzxPN+OrXfhA";
  io = [
    io-user
    io-host
  ];

  rotterdam-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL";
  rotterdam-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjXcqQqlu03x2VVTdWOyxtKRszXAKX0AxTkGvF1oeJL";
  rotterdam = [
    rotterdam-user
    rotterdam-host
  ];

  alexandria-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK95QueW+jp1ZmF299Xr3XkgHJ6dL7aZVsfWxqbOKVKA";
  alexandria = [ alexandria-host ];

  trantor-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkGuGLZPnYJbCGY4BhJ9uTupp6ruuR1NZ7FEYEaLPA7";
  trantor = [ trantor-host ];

  desktops = io ++ rotterdam;
  servers = alexandria ++ trantor;
  all-hosts = desktops ++ servers;
in
{
  "cloudflare.age".publicKeys = all-hosts;
  "webdav.env.age".publicKeys = all-hosts;
}
