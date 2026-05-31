{ ... }:

{
  imports = [
    ./packages.nix
    ./neovim.nix
    ./direnv.nix
    ./fish.nix
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./starship.nix
    ./ai-tools.nix
    ./programs
  ];

  # username / homeDirectory are set per-platform in flake.nix

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
