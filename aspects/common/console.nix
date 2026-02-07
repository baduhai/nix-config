{ ... }:
{
  flake.modules.nixos.common-console = { ... }: {
    console = {
      useXkbConfig = true;
      earlySetup = true;
    };
  };
}
