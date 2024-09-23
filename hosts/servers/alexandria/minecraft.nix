{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/data/minecraft";
    servers."kingdomcums" = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_20_1;
      openFirewall = true;
      serverProperties = {
        difficulty = "normal";
        gamemode = "survival";
        motd = "Kingdom Cums";
        online-mode = false;
        spawn-protection = false;
      };
      symlinks."mods" = pkgs.linkFarmFromDrvs "mods" (
        builtins.attrValues {
          villagerNames = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gqRXDo8B/versions/rzXhJ2pH/villagernames-1.20.1-8.1.jar";
            sha256 = "0hcbbp3zi3nnr12kian9l645f22jr7495bcrlbng46nxp9h08pg5";
          };
          lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar";
            sha256 = "1ycdvrs46bbdxsa6i38sfx70v47nvzzbmblfpy3hq3k8blsrbid0";
          };
          lootr = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EltpO5cN/versions/fqmzdpE2/lootr-fabric-1.20-0.7.33.81.jar";
            sha256 = "0db0472rb07nbc9i925qp3n7s7nmrq6q3alhprflgc9gqg0j0f14";
          };
          malilib = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/GcWjdA9I/versions/V7yLDtJV/malilib-fabric-1.20.1-0.16.3.jar";
            sha256 = "129m1jnk58p0wid5fmagqx13wp6pw4gja01yx14aljdxgzr8kqas";
          };
          immersivePaintings = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/6txNkua3/versions/UjL11A4h/immersive_paintings-0.6.7%2B1.20.1-fabric.jar";
            sha256 = "1di9a67q372z6lplnsa1kmh86armya83mimn61c8ai7izjlsfnid";
          };
          entityCulling = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/NNAgCjsB/versions/mahLIqpj/entityculling-fabric-1.6.7-mc1.20.1.jar";
            sha256 = "01iz8rgljgzl0d8gcwpmr6wcvv3b0cf1siggp3dn8q5hv9przk9k";
          };
          fabricAPI = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/P7uGFii0/fabric-api-0.92.2%2B1.20.1.jar";
            sha256 = "1z3hcxng2p9ymph1c0k729vxxaasi34n6fcdsqwx0wsmqi2gh025";
          };
          fallingTree = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/NrtzFkZE/FallingTree-1.20.1-4.3.4.jar";
            sha256 = "0sfv2laxzgmkhmr0kizi7g09r6fkccjhj9p5j0viqywnwx02r7fs";
          };
          carryOn = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/joEfVgkn/versions/Mkla4B3q/carryon-fabric-1.20.1-2.1.2.7.jar";
            sha256 = "1pgbqrjrxw7bgwn6phpywgpjfmf5h341ba93j76ibk649wbgn9cd";
          };
          collective = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/jo7YkyNS/collective-1.20.1-7.84.jar";
            sha256 = "01qvaqmd5kmxq7sins6703xq5ckc47qs5kd62gnjyfq1dbjp2y2b";
          };
          dynamicLights = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/7YjclEGc/versions/eU6PA0pr/dynamiclights-v1.8.3-mc1.17x-1.21x-mod.jar";
            sha256 = "0vdv525gis1vj514iqh4rbl6byp7k0ls3lsyj0c3db8g58d784gm";
          };
          appleSkin = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/xcauwnEB/appleskin-fabric-mc1.20.1-2.5.1.jar";
            sha256 = "1d9qmzjlk763ycmizqpmhcq0hhqw9j8hij6xk8p8l11ljr13mql5";
          };
        }
      );
    };
  };
}
