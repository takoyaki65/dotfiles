{ ... }:

{
  programs.aerospace = {
    enable = true;
    # Let launchd handle startup and keep AeroSpace running.
    launchd = {
      enable = true;
      keepAlive = true;
    };

    # Based on: https://nikitabobko.github.io/AeroSpace/guide#default-config
    settings = {
      # Persistent workspaces below require config version 2.
      config-version = 2;

      # Layout and spacing.
      accordion-padding = 16;

      # tiles | accordion
      default-root-container-layout = "tiles";

      # horizontal | vertical | auto
      default-root-container-orientation = "auto";

      # Move the pointer to the focused monitor or window.
      # See: https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-focus-changed = ["move-mouse window-lazy-center"];

      # Prevent accidental cmd-h / cmd-alt-h from leaving apps hidden.
      # See: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = true;

      # Keep numbered and app workspaces even when empty or not visible.
      persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "B" "D" "M" "S" "T"];

      # Commands to run when changing binding modes.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      on-mode-changed = [];

      # Keyboard layout: qwerty | dvorak | colemak.
      # See: https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "qwerty";

      # Gaps between windows (inner) and at screen edges (outer).
      gaps = {
        inner.horizontal = 4;
        inner.vertical = 4;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };

      mode = {
        main = {
          binding = {
            # Command reference: https://nikitabobko.github.io/AeroSpace/commands
            # Application-launch shortcuts: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget

            # Layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # Focus window
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # Move window
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            # "=" is hard to use for JIS keyboard, so we use "ctrl-h/l"
            alt-ctrl-h = "resize smart -50";
            alt-ctrl-l = "resize smart +50";

            # Switch workspaces; lettered names identify app workspaces.
            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-b = "workspace B"; # Browser
            alt-m = "workspace M"; # Mail
            alt-s = "workspace S"; # Slack
            alt-d = "workspace D"; # Discord
            alt-t = "workspace T"; # Terminal

            # Move the focused window to another workspace.
            # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-b = "move-node-to-workspace B"; # Browser
            alt-shift-m = "move-node-to-workspace M"; # Mail
            alt-shift-s = "move-node-to-workspace S"; # Slack
            alt-shift-d = "move-node-to-workspace D"; # Discord
            alt-shift-t = "move-node-to-workspace T"; # Terminal

            # Fullscreen the focused window.
            alt-shift-f = "fullscreen";

            # Return to the previous workspace.
            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
            alt-tab = "workspace-back-and-forth";
            # Move the current workspace to the next monitor, wrapping around.
            # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            # Enter service mode for layout maintenance.
            # See: https://nikitabobko.github.io/AeroSpace/commands#mode
            alt-shift-semicolon = "mode service";
          };
        };

        # Layout maintenance; esc reloads the config and returns to main mode.
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        service = {
          binding = {
            esc = ["reload-config" "mode main"];
            r = ["flatten-workspace-tree" "mode main"]; # reset-layout
            f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
            backspace = ["close-all-windows-but-current" "mode main"];

            # Sticky-window support: https://github.com/nikitabobko/AeroSpace/issues/2

            alt-shift-h = ["join-with left" "mode main"];
            alt-shift-j = ["join-with down" "mode main"];
            alt-shift-k = ["join-with  up" "mode main"];
            alt-shift-l = ["join-with right" "mode main"];
          };
        };
      };

      # Route new application windows to the named workspaces above.
      on-window-detected = [
        {
          check-further-callbacks = false;
          "if".app-id = "com.google.Chrome";
          run = [
            "move-node-to-workspace B"
          ];
        }
        {
          check-further-callbacks = false;
          "if".app-id = "com.apple.mail";
          run = [
            "move-node-to-workspace M"
          ];
        }
        {
          check-further-callbacks = false;
          "if".app-id = "com.tinyspeck.slackmacgap";
          run = [
            "move-node-to-workspace S"
          ];
        }
        {
          check-further-callbacks = false;
          "if".app-id = "com.hnc.Discord";
          run = [
            "move-node-to-workspace D"
          ];
        }
        {
          check-further-callbacks = false;
          "if".app-id = "com.mitchellh.ghostty";
          run = [
            "move-node-to-workspace T"
          ];
        }
        {
          check-further-callbacks = false;
          "if".app-id = "com.apple.Terminal";
          run = [
            "move-node-to-workspace T"
          ];
        }
      ];
    };
  };
}
