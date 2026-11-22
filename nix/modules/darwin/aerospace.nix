{ ... }:

{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };

    # Based on: https://nikitabobko.github.io/AeroSpace/guide#default-config
    settings = {
      config-version = 2;

      accordion-padding = 16;

      default-root-container-layout = "tiles";

      default-root-container-orientation = "auto";

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-focus-changed = ["move-mouse window-lazy-center"];

      # Prevent accidental cmd-h / cmd-alt-h from hiding applications.
      automatically-unhide-macos-hidden-apps = true;

      persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "B" "D" "M" "S" "T"];

      on-mode-changed = [];

      key-mapping.preset = "qwerty";

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

            # "=" is hard to use for JIS keyboard, so we use "ctrl-h/l"
            alt-ctrl-h = "resize smart -50";
            alt-ctrl-l = "resize smart +50";

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

            alt-shift-f = "fullscreen";

            alt-tab = "workspace-back-and-forth";
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            alt-shift-semicolon = "mode service";
          };
        };

        service = {
          binding = {
            esc = ["reload-config" "mode main"];
            r = ["flatten-workspace-tree" "mode main"]; # reset-layout
            f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
            backspace = ["close-all-windows-but-current" "mode main"];

            alt-shift-h = ["join-with left" "mode main"];
            alt-shift-j = ["join-with down" "mode main"];
            alt-shift-k = ["join-with  up" "mode main"];
            alt-shift-l = ["join-with right" "mode main"];
          };
        };
      };

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
