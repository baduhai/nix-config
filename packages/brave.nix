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
    in
    {
      packages.brave = pkgs.symlinkJoin {
        name = "brave";
        paths = [
          brave-launcher
          brave-policy
          pkgs.brave
        ];
        postBuild = ''
          desktop="$out/share/applications/brave-browser.desktop"
          if [ -L "$desktop" ]; then
            cp --remove-destination "$(readlink "$desktop")" "$desktop"
          fi
          sed -i \
            "s|^Exec=.*|Exec=$out/bin/brave %U|g" \
            "$desktop"
        '';
      };
    };
}
