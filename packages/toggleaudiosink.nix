{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.toggleaudiosink = pkgs.writeShellScriptBin "toggleaudiosink" ''
        #!/usr/bin/env bash

        sound_server="pipewire"

        # Grab a count of how many audio sinks we have
        sink_count=$(${pkgs.pulseaudio}/bin/pactl list sinks | grep -c "Sink #[[:digit:]]")
        # Create an array of the actual sink IDs
        sinks=()
        mapfile -t sinks < <(${pkgs.pulseaudio}/bin/pactl list sinks | grep 'Sink #[[:digit:]]' | sed -n -e 's/.*Sink #\([[:digit:]]\)/\1/p')
        # Get the ID of the active sink
        active_sink_name=$(${pkgs.pulseaudio}/bin/pactl info | grep 'Default Sink:' | sed -n -e 's/.*Default Sink:[[:space:]]\+\(.*\)/\1/p')
        active_sink=$(${pkgs.pulseaudio}/bin/pactl list sinks | grep -B 2 "$active_sink_name" | sed -n -e 's/Sink #\([[:digit:]]\)/\1/p' | head -n 1)

        # Get the ID of the last sink in the array
        final_sink=''${sinks[$((sink_count - 1))]}

        # Find the index of the active sink
        for index in "''${!sinks[@]}"; do
          if [[ "''${sinks[$index]}" == "$active_sink" ]]; then
            active_sink_index=$index
          fi
        done

        # Default to the first sink in the list
        next_sink=''${sinks[0]}
        next_sink_index=0

        # If we're not at the end of the list, move up the list
        if [[ $active_sink -ne $final_sink ]]; then
          next_sink_index=$((active_sink_index + 1))
          next_sink=''${sinks[$next_sink_index]}
        fi

        # Change the default sink
        # Get the name of the next sink
        next_sink_name=$(${pkgs.pulseaudio}/bin/pactl list sinks | grep -C 2 "Sink #$next_sink" | sed -n -e 's/.*Name:[[:space:]]\+\(.*\)/\1/p' | head -n 1)
        ${pkgs.pulseaudio}/bin/pactl set-default-sink "$next_sink_name"

        # Move all inputs to the new sink
        for app in $(${pkgs.pulseaudio}/bin/pactl list sink-inputs | sed -n -e 's/.*Sink Input #\([[:digit:]]\)/\1/p'); do
          ${pkgs.pulseaudio}/bin/pactl "move-sink-input $app $next_sink"
        done
      '';
    };
}
