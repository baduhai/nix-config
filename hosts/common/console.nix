{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  console = {
    useXkbConfig = true;
    earlySetup = true;
  };
}
