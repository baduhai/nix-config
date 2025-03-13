{ hostType, lib, ... }:

{
  config = lib.mkMerge [
    # Common configuration
    {
      console = {
        useXkbConfig = true;
        earlySetup = true;
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
    })
  ];
}
