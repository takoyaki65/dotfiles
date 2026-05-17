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
    ./tmux.nix
  ];

  # username / homeDirectory are set per-platform in flake.nix

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
