let
  io-user =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcwF1yuWEfYGScNocEbs0AmGxyTIzGc4/IhpU587SJE";
  io-host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCIrKJk5zWzWEHvLMPMK8T3PyeBjsCsqzxPN+OrXfhA";
  io = [ io-user io-host ];

  rotterdam-user =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL";
  rotterdam-host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7zAxgU8LNi5/O5XgoOcLKjbNMmO2S7jAuCI9Nr/V4v";
  rotterdam = [ rotterdam-user rotterdam-host ];

  alexandria-host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK95QueW+jp1ZmF299Xr3XkgHJ6dL7aZVsfWxqbOKVKA";
  alexandria = [ alexandria-host ];

  desktops = io ++ rotterdam;
  servers = alexandria;
  all-hosts = desktops ++ servers;
in {
  "nextcloud-secrets.json.age".publicKeys = all-hosts;
  "nextcloud-adminpass.age".publicKeys = all-hosts;
  "cloudflare.age".publicKeys = all-hosts;
  "paperless.age".publicKeys = all-hosts;
  "podsync.toml.age".publicKeys = all-hosts;
}
