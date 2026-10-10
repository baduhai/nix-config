{ ... }:
{
  flake.modules = {
    nixos.ai =
      { inputs, pkgs, ... }:
      {
        environment.systemPackages =
          (with pkgs; [
            playwright
          ])
          ++ (with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
            # OpenCode v2 installs as `opencode2`; the sleep-inhibit plugin needs >=2.0.14.
            opencode2
          ]);

        nix.settings = {
          extra-substituters = [ "https://cache.numtide.com" ];
          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
      };
    homeManager.ai =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      {
        home.packages = [ pkgs.gcli ];

        # OpenCode v2 ships as `opencode2`; keep the familiar command name.
        home.shellAliases.opencode = "opencode2";

        programs.opencode = {
          enable = true;
          package = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;
          tui = {
            theme = "system";
            autoupdate = false;
          };
          context = ''
            # Global rules

            ## Git / VCS
            - NEVER run `git push` (incl. `-f`, `--force`, `--force-with-lease`, `--tags`)
              without explicit confirmation from the user in the current conversation.
            - For forge operations (GitHub/GitLab/Gitea/Forgejo) use `gcli`. Creating or
              merging PRs/MRs, creating/deleting repos, releases, or otherwise writing to a
              forge also requires explicit confirmation first.
            - Never pass `--yes`/`-y` to skip gcli's own confirmation.

            ## Browser automation
            - Use the headless server (`playwright-headless`) by default.
            - Use the visible server (`playwright`) only when the user asks to see the
              browser.
            - Both run isolated, ephemeral profiles: logins/cookies are discarded when
              the browser closes.
            - Both are pinned to the system Chromium (`ungoogled-chromium`); do not
              install another browser unless the user explicitly asks.
          '';
          settings = {
            # Prevent suspend/hibernation while agents are working.
            plugins = [
              {
                package = "opencode-sleep-inhibit";
                options = {
                  mode = "sleep";
                  cooldownMinutes = 0;
                };
              }
            ];
            mcp = {
              nixos = {
                type = "local";
                command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
                enabled = true;
              };
              # Default browser for agent use: no window, works on display-less hosts.
              playwright-headless = {
                type = "local";
                command = [
                  "${pkgs.playwright-mcp}/bin/playwright-mcp"
                  "--headless"
                  "--isolated"
                  "--executable-path"
                  "${pkgs.ungoogled-chromium}/bin/chromium"
                ];
                enabled = true;
              };
              # Visible window, only when the user wants to watch the browser.
              playwright = {
                type = "local";
                command = [
                  "${pkgs.playwright-mcp}/bin/playwright-mcp"
                  "--isolated"
                  "--executable-path"
                  "${pkgs.ungoogled-chromium}/bin/chromium"
                ];
                enabled = true;
              };
            };
            permission.bash = {
              "git push*" = "ask";
              "git * push*" = "ask";

              # gcli forge mutations (last matching rule wins; unmatched commands stay allow)
              "gcli * create*" = "ask";
              "gcli * delete*" = "ask";
              "gcli * merge*" = "ask";
              "gcli * close*" = "ask";
              "gcli * reopen*" = "ask";
              "gcli * edit*" = "ask";
              "gcli * modify*" = "ask";
              "gcli * set-visibility*" = "ask";
              "gcli * approve*" = "ask";
              "gcli * unapprove*" = "ask";
              "gcli * review*" = "ask";
              "gcli * assign*" = "ask";
              "gcli * title *" = "ask";
              "gcli * labels *" = "ask";
              "gcli * milestone *" = "ask";
              "gcli * cancel*" = "ask";
              "gcli * retry*" = "ask";
              "gcli * upload*" = "ask";
              "gcli comment*" = "ask";
              "gcli config*" = "ask";
              "gcli api*" = "ask";
            };
          };
        };
      };
  };
}
