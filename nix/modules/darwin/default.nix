{ pkgs, ... }:

{
  # Primary user (required by recent nix-darwin)
  system.primaryUser = "mizokami";

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "mizokami" ];
  };

  # System packages (macOS only)
  environment.systemPackages = with pkgs; [
    # Add macOS-specific packages here
  ];

  fonts = {
    packages = with pkgs; [
      udev-gothic
      udev-gothic-nf
    ];
  };

  # Declare user so home-manager can resolve username/homeDirectory
  users.users.mizokami = {
    name = "mizokami";
    home = "/Users/mizokami";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # Add fish shells to system shells
  environment.shells = [ pkgs.fish ];

  # macOS system defaults
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      # Disable switching to a workspace that has a window of the application open,
      # to prevent conflicts of Aerospace
      AppleSpacesSwitchOnActivate = false;
    };
    dock = {
      autohide = false;
      show-recents = false;
      # Disable auto-rearrange feature for spaces, to improve consistency
      mru-spaces = false;
      # Disable grouping windows by application in Mission Control's expose
      expose-group-apps = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };
    # Reduce motion when switching between screens or opening apps
    universalaccess.reduceMotion = true;
    # Displays have different spaces
    spaces.spans-displays = false;
  };

  imports = [
    ./aerospace.nix
  ];

  # Homebrew configuration (managed declaratively by nix-darwin)
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    casks = [
      "cloudflare-warp"
      "cmux"
      "codex-app"
      "discord"
      "ghostty"
    ];

    masApps = {
      "Slack" = 803453959;
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 6;
}
