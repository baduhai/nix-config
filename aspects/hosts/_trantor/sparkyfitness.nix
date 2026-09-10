{
  config,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  imports = [ inputs.sparkyfitness.nixosModules.sparkyfitness ];

  services.sparkyfitness = {
    enable = true;
    frontendUrl = "https://fitness.baduhai.dev";
    nginx.virtualHost = "fitness.baduhai.dev";
    environmentFile = config.age.secrets.sparkyfitness.path;
    extraEnvironment.TZ = "America/Bahia";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."fitness.baduhai.dev" = { };
  };

  age.secrets.sparkyfitness = {
    file = "${inputs.self}/secrets/sparkyfitness.env.age";
    owner = "root";
  };

  environment.persistence.main.directories = [
    {
      directory = "/var/lib/sparkyfitness";
      user = "sparkyfitness";
      group = "sparkyfitness";
      mode = "0700";
    }
    {
      directory = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
      mode = "0700";
    }
  ];
}
