{ ... }:

{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };

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

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = false;

      # List of workspaces that should stay alive even when they contain no windows,
      # even when they are invisible.
      # This config version is only available since 'config-version = 2'
      # Fallback value (if you omit the key): persistent-workspaces = []
      persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B"
                               "C" "D" "E" "F" "G" "I" "M" "N" "O" "P" "Q"
                               "R" "S" "T" "U" "V" "W" "X" "Y" "Z"];
      
      # A callback that runs every time binding mode changes
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      on-mode-changed = [];

      # Possible values: (qwerty|dvorak|colemak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "qwerty";

      gaps = {
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
            alt-a = "workspace A"; # In your config, you can drop workspace bindings that you don't need
            alt-b = "workspace B";
            alt-c = "workspace C";
            alt-d = "workspace D";
            alt-e = "workspace E";
            alt-f = "workspace F";
            alt-g = "workspace G";
            alt-i = "workspace I";
            alt-m = "workspace M";
            alt-n = "workspace N";
            alt-o = "workspace O";
            alt-p = "workspace P";
            alt-q = "workspace Q";
            alt-r = "workspace R";
            alt-s = "workspace S";
            alt-t = "workspace T";
            alt-u = "workspace U";
            alt-v = "workspace V";
            alt-w = "workspace W";
            alt-x = "workspace X";
            alt-y = "workspace Y";
            alt-z = "workspace Z";
          };
        };
      };
    };
  };
}
