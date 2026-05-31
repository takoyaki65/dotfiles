{ ... }:

{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };

    settings = {
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
          };
        };
      };
    };
  };
}
