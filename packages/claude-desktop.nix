{ inputs, ... }:

{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pname = "claude-desktop";
      version = "1.0.1768";

      srcs.x86_64-linux = pkgs.fetchurl {
        url = "https://downloads.claude.ai/releases/win32/x64/1.0.1768/Claude-67d01376d0e9d08b328455f6db9e63b0d603506a.exe";
        hash = "sha256-x76Qav38ya3ObpWIq3dDowo79LgvVquMfaZeH8M1LUk=;";
      };

      src =
        srcs.${pkgs.stdenv.hostPlatform.system} or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");

      claudeNativeStub = ''
        // Stub implementation of claude-native using KeyboardKey enum values
        const KeyboardKey = {
          Backspace: 43, Tab: 280, Enter: 261, Shift: 272, Control: 61, Alt: 40,
          CapsLock: 56, Escape: 85, Space: 276, PageUp: 251, PageDown: 250,
          End: 83, Home: 154, LeftArrow: 175, UpArrow: 282, RightArrow: 262,
          DownArrow: 81, Delete: 79, Meta: 187
        };
        Object.freeze(KeyboardKey);
        module.exports = {
          getWindowsVersion: () => "10.0.0",
          setWindowEffect: () => {},
          removeWindowEffect: () => {},
          getIsMaximized: () => false,
          flashFrame: () => {},
          clearFlashFrame: () => {},
          showNotification: () => {},
          setProgressBar: () => {},
          clearProgressBar: () => {},
          setOverlayIcon: () => {},
          clearOverlayIcon: () => {},
          KeyboardKey
        };
      '';
    in
    {
      packages.claude-desktop = pkgs.stdenv.mkDerivation rec {
        inherit pname version src;

        nativeBuildInputs = with pkgs; [
          makeWrapper
          copyDesktopItems
          p7zip
          unzip
          nodejs
          graphicsmagick
        ];

        buildInputs = [ pkgs.electron ];

        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "claude-desktop";
            desktopName = "Claude";
            comment = "AI assistant from Anthropic";
            exec = "claude-desktop %u";
            icon = "claude-desktop";
            categories = [
              "Network"
              "Chat"
              "Office"
            ];
            mimeTypes = [ "x-scheme-handler/claude" ];
            startupNotify = true;
            startupWMClass = "Claude";
          })
        ];

        unpackPhase = ''
          runHook preUnpack

          # Extract the Windows installer - use -y to auto-overwrite
          7z x -y $src -o./extracted

          # The installer contains a NuGet package
          if [ -f ./extracted/AnthropicClaude-*-full.nupkg ]; then
            echo "Found NuGet package, extracting..."
            # NuGet packages are just zip files
            unzip -q ./extracted/AnthropicClaude-*-full.nupkg -d ./nupkg

            # Extract app.asar to modify it
            if [ -f ./nupkg/lib/net45/resources/app.asar ]; then
              echo "Extracting app.asar..."
              ${pkgs.asar}/bin/asar extract ./nupkg/lib/net45/resources/app.asar ./app

              # Also copy the unpacked resources
              if [ -d ./nupkg/lib/net45/resources/app.asar.unpacked ]; then
                cp -r ./nupkg/lib/net45/resources/app.asar.unpacked/* ./app/
              fi

              # Copy additional resources
              mkdir -p ./app/resources
              mkdir -p ./app/resources/i18n
              cp ./nupkg/lib/net45/resources/Tray* ./app/resources/ || true
              cp ./nupkg/lib/net45/resources/*-*.json ./app/resources/i18n/ || true
            fi
          else
            echo "NuGet package not found"
            ls -la ./extracted/
            exit 1
          fi

          runHook postUnpack
        '';

        buildPhase = ''
          runHook preBuild

          # Replace the Windows-specific claude-native module with a stub
          if [ -d ./app/node_modules/claude-native ]; then
            echo "Replacing claude-native module with Linux stub..."
            rm -rf ./app/node_modules/claude-native/*.node
            cat > ./app/node_modules/claude-native/index.js << 'EOF'
          ${claudeNativeStub}
          EOF
          fi

          # Fix the title bar detection (from aaddrick script)
          echo "Fixing title bar detection..."
          SEARCH_BASE="./app/.vite/renderer/main_window/assets"
          if [ -d "$SEARCH_BASE" ]; then
            TARGET_FILE=$(find "$SEARCH_BASE" -type f -name "MainWindowPage-*.js" | head -1)
            if [ -n "$TARGET_FILE" ]; then
              echo "Found target file: $TARGET_FILE"
              # Replace patterns like 'if(!VAR1 && VAR2)' with 'if(VAR1 && VAR2)'
              sed -i -E 's/if\(!([a-zA-Z]+)[[:space:]]*&&[[:space:]]*([a-zA-Z]+)\)/if(\1 \&\& \2)/g' "$TARGET_FILE"
              echo "Title bar fix applied"
            fi
          fi

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib/claude-desktop

          # Repack the modified app as app.asar
          cd ./app
          ${pkgs.asar}/bin/asar pack . ../app.asar
          cd ..

          # Copy resources
          mkdir -p $out/lib/claude-desktop/resources
          cp ./app.asar $out/lib/claude-desktop/resources/

          # Create app.asar.unpacked directory with the stub
          mkdir -p $out/lib/claude-desktop/resources/app.asar.unpacked/node_modules/claude-native
          cat > $out/lib/claude-desktop/resources/app.asar.unpacked/node_modules/claude-native/index.js << 'EOF'
          ${claudeNativeStub}
          EOF

          # Copy other resources
          if [ -d ./nupkg/lib/net45/resources ]; then
            cp ./nupkg/lib/net45/resources/*.png $out/lib/claude-desktop/resources/ 2>/dev/null || true
            cp ./nupkg/lib/net45/resources/*.ico $out/lib/claude-desktop/resources/ 2>/dev/null || true
            cp ./nupkg/lib/net45/resources/*.json $out/lib/claude-desktop/resources/ 2>/dev/null || true
          fi

          # Create wrapper script
          makeWrapper ${pkgs.electron}/bin/electron $out/bin/claude-desktop \
            --add-flags "$out/lib/claude-desktop/resources/app.asar" \
            --set DISABLE_AUTOUPDATER 1 \
            --set NODE_ENV production

          # Extract and install icons in multiple sizes
          if [ -f ./extracted/setupIcon.ico ]; then
            echo "Converting and installing icons..."
            # Count frames in the ICO file and extract each one
            frame_count=$(gm identify ./extracted/setupIcon.ico | wc -l)
            for i in $(seq 0 $((frame_count - 1))); do
              gm convert "./extracted/setupIcon.ico[$i]" "./extracted/setupIcon-$i.png" 2>/dev/null || true
            done

            # Loop through converted icons and install them by size
            for img in ./extracted/setupIcon-*.png; do
              if [ -f "$img" ]; then
                size=$(gm identify -format "%wx%h" "$img")
                # Skip smallest icons (16x16 and 32x32) as they're too low quality
                if [ "$size" != "16x16" ] && [ "$size" != "32x32" ]; then
                  mkdir -p "$out/share/icons/hicolor/$size/apps"
                  cp "$img" "$out/share/icons/hicolor/$size/apps/claude-desktop.png"
                fi
              fi
            done
          fi

          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "Claude Desktop - AI assistant from Anthropic";
          homepage = "https://claude.ai";
          license = licenses.unfree;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          maintainers = [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "claude-desktop";
        };
      };
    };
}
