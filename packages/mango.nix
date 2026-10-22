{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      # Patch mango's scroller layout to centre the whole strip when the
      # columns do not fill the work area (see mango-scroller-center.patch).
      packages.mango = pkgs.mango.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./mango-scroller-center.patch ];
      });
    };
}
