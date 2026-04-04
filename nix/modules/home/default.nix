{ pkgs, dotfilesDir, ... }:

{
  imports = [
    ./packages.nix
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
  ];

  home.username = "mizokami";
  home.homeDirectory = "/Users/mizokami";

  # Neovim config — link the raw lua files as-is
  xdg.configFile."nvim".source = "${dotfilesDir}/nvim";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
