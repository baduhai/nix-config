{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.niri-auto-centre = pkgs.writeShellApplication {
        name = "niri-auto-centre";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          while true; do
              ACTIVE_WORKSPACE=$(niri msg --json workspaces | jq -r '.[] | select(.is_active == true)')
              WORKSPACE_ID=$(echo "$ACTIVE_WORKSPACE" | jq -r '.id')
              OUTPUT_NAME=$(echo "$ACTIVE_WORKSPACE" | jq -r '.output')
              
              MONITOR_WIDTH=$(niri msg --json outputs | jq -r ".\"$OUTPUT_NAME\".logical.width")
              
              SUMMED_TILE_WIDTH=$(niri msg --json windows | jq --argjson wid "$WORKSPACE_ID" -r '
                  [.[] | select(.workspace_id == $wid) | {col: .layout.pos_in_scrolling_layout[0], width: .layout.tile_size[0]}]
                  | group_by(.col) | map(first.width) | add
              ')
              
              if awk "BEGIN {exit !($SUMMED_TILE_WIDTH < $MONITOR_WIDTH)}"; then
                  niri msg action center-visible-columns
              fi
              
              sleep 0.1
          done
        '';
      };
    };
}
