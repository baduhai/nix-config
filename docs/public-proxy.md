# Publicly Proxying a Service

How to make an internal service publicly accessible through trantor, using the same pattern as vaultwarden.

The flow: `internet → trantor:443 (TLS) → alexandria:$PORT via Tailscale → service`

## Steps

### 1. Mark the service as public

In `data/services.nix`, add `public = true` to the service:

```nix
{
  name = "my-service";
  domain = "my.baduhai.dev";
  host = "alexandria";
  public = true;
}
```

This tells the Terraform config to point DNS at trantor's public IP instead of the Tailscale IP. Internal clients (Tailscale/LAN) still hit alexandria directly via split DNS.

### 2. Make the service reachable from trantor

On the host running the service (usually alexandria), the service must listen on `0.0.0.0` so it accepts connections from the Tailscale interface. Add a firewall rule for the port:

```nix
# Example: aspects/hosts/_alexandria/my-service.nix
{
  services.my-service = {
    enable = true;
    # Bind to all interfaces, not just 127.0.0.1
    listenAddr = "0.0.0.0:12345";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."my.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:12345/";
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 12345 ];
}
```

Only port `12345` is open on the `tailscale0` interface — the LAN and public internet can't reach it directly.

### 3. Proxy from trantor

Create a module in `aspects/hosts/_trantor/` that adds an ACME certificate and nginx vhost proxying to the service's Tailscale IP:

```nix
# aspects/hosts/_trantor/my-service-proxy.nix
{
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;

  services = inputs.self.services;

  svc = lib.findFirst
    (s: s.name == "my-service")
    (throw "my-service not found in services")
    services;
in

{
  security.acme.certs."my.baduhai.dev" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."my.baduhai.dev".locations."/".proxyPass =
      "http://${svc.tailscaleIP}:12345/";
  };
}
```

`inputs.self.services` gives the enriched service list with `tailscaleIP` resolved — no hardcoded IPs needed.

### 4. Deploy

1. **Service host first** (e.g. alexandria) — service must be listening on `0.0.0.0` before trantor tries to reach it
2. **trantor** — adds the ACME cert and proxy vhost
3. **Terraform** — updates Cloudflare DNS to point the domain at trantor's public IP
