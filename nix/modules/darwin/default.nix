{ pkgs, ... }:

{
  # Primary user (required by recent nix-darwin)
  system.primaryUser = "mizokami";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages (macOS only)
  environment.systemPackages = with pkgs; [
    # Add macOS-specific packages here
  ];

  # Declare user so home-manager can resolve username/homeDirectory
  users.users.mizokami = {
    name = "mizokami";
    home = "/Users/mizokami";
    shell = pkgs.fish;
  };

  # Set fish as default shell
  programs.fish.enable = true;

  # macOS system defaults
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
    dock = {
      autohide = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 6;
}
