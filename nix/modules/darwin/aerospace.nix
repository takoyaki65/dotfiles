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
      # Config version for compatibility and deprecations
      # Fallback value (if you omit the key): config-version = 1
      config-version = 2;

      # This value is false because launched agents are now handled by launchd
      # start-at-login = false;
      # after-login-command = [];
      accordion-padding = 16;

      # tiles | accordion
      default-root-container-layout = "tiles";

      # horizontal | vertical | auto
      default-root-container-orientation = "auto";

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-focus-changed = ["move-mouse window-lazy-center"];

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = true;

      # List of workspaces that should stay alive even when they contain no windows,
      # even when they are invisible.
      # This config version is only available since 'config-version = 2'
      # Fallback value (if you omit the key): persistent-workspaces = []
      persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "B" "D" "M" "S" "T"];
      
      # A callback that runs every time binding mode changes
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      on-mode-changed = [];

      # Possible values: (qwerty|dvorak|colemak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 2;
        inner.vertical = 2;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };

      mode = {
        main = {
          binding = {
            # All possible keys:
            # - Letters.        a, b, c, ..., z
            # - Numbers.        0, 1, 2, ..., 9
            # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
            # - F-keys.         f1, f2, ..., f20
            # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
            #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
            #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
            #                   sectionSign (ISO keyboards only, european keyboards only)
            # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
            #                   keypadMinus, keypadMultiply, keypadPlus
            # - Arrows.         left, down, up, right

            # All possible modifiers: cmd, alt, ctrl, shift

            # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

            # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
            # You can uncomment the following lines to open up terminal with alt + enter shortcut
            # (like in i3)
            # alt-enter = '''exec-and-forget osascript -e '
            # tell application "Terminal"
            #     do script
            #     activate
            # end tell'
            # '''

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
            
            # Fullscreen currently focuse window
            alt-shift-f = "fullscreen";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
            alt-tab = "workspace-back-and-forth";
            # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            # See: https://nikitabobko.github.io/AeroSpace/commands#mode
            alt-shift-semicolon = "mode service";
          };
        };

        # 'service' binding mode declaration.
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        service = {
          binding = {
            esc = ["reload-config" "mode main"];
            r = ["flatten-workspace-tree" "mode main"]; # reset-layout
            f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
            backspace = ["close-all-windows-but-current" "mode main"];

            # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
            #s = ['layout sticky tiling', 'mode main']

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
