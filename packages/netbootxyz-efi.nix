{ ... }:

{
  perSystem =
    { pkgs, lib, ... }:
    let
      version = "3.0.3";
      platformMap = {
        aarch64-linux = {
          url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz-arm64.efi";
          hash = "sha256-6Oq778g8HbSa53PZ4zGM8JEYKlH7uGr/h7yHHoZ65ho=";
        };
        x86_64-linux = {
          url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz-legacy.efi";
          hash = "sha256-xns+RnTf5ZJ71ujLSiA+VCLlCiyPWQ6ZGSlKX5ONWMQ=";
        };
      };
    in
    {
      packages.netbootxyz-efi = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "netboot.xyz-efi";
        inherit version;

        src = pkgs.fetchurl {
          inherit
            (platformMap.${pkgs.stdenv.hostPlatform.system}
              or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}")
            )
            url
            hash
            ;
        };

        dontUnpack = true;

        postInstall = ''
          cp $src $out
        '';

        meta = {
          homepage = "https://netboot.xyz/";
          description = "Tool to boot OS installers and utilities over the network, to be run from a bootloader";
          license = lib.licenses.asl20;
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          platforms = builtins.attrNames platformMap;
          maintainers = with lib.maintainers; [ pinpox ];
        };
      });
    };
}
