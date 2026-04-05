{ dotfilesDir, ... }:

{
  imports = [
    ./packages.nix
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
  ];

  # username / homeDirectory are set per-platform in flake.nix

  # Neovim config — link the raw lua files as-is
  xdg.configFile."nvim".source = "${dotfilesDir}/nvim";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
