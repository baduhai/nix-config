{ ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      # Managed policy (enforced, user cannot override)
      brave-policy = pkgs.writeTextFile {
        name = "brave-managed-policy.json";
        destination = "/etc/brave/policies/managed/policy.json";
        text = builtins.toJSON {
          # ── Startup / UI ────────────────────────────────────────────────
          DefaultBrowserSettingEnabled = false; # Never ask to set as default
          PromotionalTabsEnabled = false; # No welcome/promo pages
          RestoreOnStartup = 5; # Open new tab on startup
          NewTabPageLocation = "about:blank"; # New tab = blank page
          BookmarkBarEnabled = false; # Never show bookmarks bar
          # ── Search engine ───────────────────────────────────────────────
          DefaultSearchProviderEnabled = true;
          DefaultSearchProviderName = "Google";
          DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
          DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
          # ── HTTPS ────────────────────────────────────────────────────────
          HttpsOnlyMode = "force_enabled"; # Strict HTTPS upgrade
          # ── Cookies ──────────────────────────────────────────────────────
          DefaultCookiesSetting = 1; # Allow all cookies
          # ── Passwords / Autofill ─────────────────────────────────────────
          PasswordManagerEnabled = false;
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          PaymentMethodQueryEnabled = false;
          # ── Background running ───────────────────────────────────────────
          BackgroundModeEnabled = false;
          # ── Clear data on exit ───────────────────────────────────────────
          ClearBrowsingDataOnExitList = [
            "browsing_history"
            "download_history"
            "cookies_and_other_site_data"
            "cached_images_and_files"
            "password_signin"
            "autofill"
            "site_settings"
            "hosted_app_data"
          ];
          # ── Brave data collection / telemetry ────────────────────────────
          BraveP3AEnabled = false; # Product analytics
          BraveStatsPingEnabled = false; # Usage ping
          BraveWebDiscoveryEnabled = false; # Web discovery project
          MetricsReportingEnabled = false; # Chromium UMA metrics
          SafeBrowsingEnabled = false;
          SafeBrowsingExtendedReportingEnabled = false;
          SafeBrowsingDeepScanningEnabled = false;
          SearchSuggestEnabled = false;
          # ── Web3 / Crypto ────────────────────────────────────────────────
          BraveWalletDisabled = true;
          BraveRewardsDisabled = true;
          BraveVPNDisabled = true;
          TorDisabled = true;
          # ── Leo / AI ─────────────────────────────────────────────────────
          BraveAIChatEnabled = false;
          # ── Other Brave features ─────────────────────────────────────────
          BraveTalkDisabled = true;
          # ── Privacy Sandbox (Chromium) ───────────────────────────────────
          PrivacySandboxPromptEnabled = false;
          PrivacySandboxAdTopicsEnabled = false;
          PrivacySandboxSiteEnabledAdsEnabled = false;
          PrivacySandboxAdMeasurementEnabled = false;
          # ── Misc Chromium ────────────────────────────────────────────────
          WebRtcEventLogCollectionAllowed = false;
          EnableMediaRouter = false;
        };
      };

      # Seeded Preferences (first-run defaults, user can override)
      # These keys have no policy or CLI equivalent. Brave writes over this
      # file at runtime so this only sets the initial state on a fresh profile.
      brave-prefs = pkgs.writeText "brave-initial-prefs.json" (
        builtins.toJSON {
          brave = {
            tabs.vertical_tabs_enabled = true;
            sidebar.sidebar_show_option = 3;
            window_closing_confirm = false;
          };
          browser.custom_chrome_frame = true;
          tab_hover_cards.tab_hover_card_images_enabled = true;
        }
      );

      brave-launcher = pkgs.writeShellScriptBin "brave" ''
        RUNTIME_DIR="/tmp/brave-$$"
        CONFIG_DIR="$RUNTIME_DIR/config/BraveSoftware"
        CACHE_DIR="$RUNTIME_DIR/cache/BraveSoftware"
        POLICY="${brave-policy}/etc/brave/policies/managed/policy.json"

        mkdir -p "$CONFIG_DIR/Brave-Browser/Default"
        mkdir -p "$CACHE_DIR"
        cp ${brave-prefs} "$CONFIG_DIR/Brave-Browser/Default/Preferences"
        chmod 600 "$CONFIG_DIR/Brave-Browser/Default/Preferences"

        trap 'rm -rf "$RUNTIME_DIR"' EXIT

        ${pkgs.bubblewrap}/bin/bwrap \
          --ro-bind /nix/store /nix/store \
          --ro-bind /etc/fonts /etc/fonts \
          --bind "$CONFIG_DIR" "$HOME/.config/BraveSoftware" \
          --bind "$CACHE_DIR" "$HOME/.cache/BraveSoftware" \
          --ro-bind "$POLICY" /etc/brave/policies/managed/policy.json \
          --dev /dev \
          --proc /proc \
          --tmpfs /tmp \
          --bind /run /run \
          --die-with-parent \
          -- ${pkgs.brave}/bin/brave --no-first-run "$@"
      '';

      brave-desktop = pkgs.writeTextFile {
        name = "amnesiac-brave.desktop";
        destination = "/share/applications/amnesiac-brave.desktop";
        text = "[Desktop Entry]
Version=1.0
Name=Amnesiac Brave
GenericName=Amnesiac Web Browser
Comment=Access the internet, leave no trace on your system
Exec=@BRAVE_WRAPPER@ %U
StartupNotify=true
Icon=amnesiac-brave
Type=Application
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/chromium;
Actions=new-window

[Desktop Action new-window]
Name=New Window
Exec=@BRAVE_WRAPPER@ %U
";
      };

      amnesiac-brave-icon =
        pkgs.runCommand "amnesiac-brave-icon"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
          }
          ''
            mkdir -p "$out/share/icons/hicolor/256x256/apps"
            convert ${pkgs.brave}/share/icons/hicolor/256x256/apps/brave-browser.png \
              -modulate 100,100,270 \
              "$out/share/icons/hicolor/256x256/apps/amnesiac-brave.png"
            for size in 16 24 32 48 64; do
              mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
              convert ${pkgs.brave}/share/icons/hicolor/''${size}x''${size}/apps/brave-browser.png \
                -modulate 100,100,270 \
                "$out/share/icons/hicolor/''${size}x''${size}/apps/amnesiac-brave.png"
            done
          '';

    in
    {
      packages.amnesiac-brave = pkgs.symlinkJoin {
        name = "amnesiac-brave";
        paths = [
          brave-launcher
          brave-policy
          brave-desktop
          amnesiac-brave-icon
          pkgs.brave
        ];
        postBuild = ''
          brave_bin="$(readlink -f "$out/bin/brave")"

          amnesiac_desktop="$out/share/applications/amnesiac-brave.desktop"
          if [ -L "$amnesiac_desktop" ]; then
            cp --remove-destination "$(readlink "$amnesiac_desktop")" "$amnesiac_desktop"
          fi
          sed -i \
            "s|@BRAVE_WRAPPER@|$brave_bin|g" \
            "$amnesiac_desktop"

          rm -f "$out/share/applications/brave-browser.desktop"
          rm -f "$out/share/applications/com.brave.Browser.desktop"

          rm -f "$out/share/icons/hicolor/"*/apps/brave-browser.png
        '';
      };
    };
}
