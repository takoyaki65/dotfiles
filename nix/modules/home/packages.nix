{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Essentials
    tmux

    # Editors & language servers
    helix
    nixd

    # Search & file utilities
    ripgrep
    fd
    fzf
    zoxide
    bat
    eza
    jq
    dust
    yazi
    trash-cli

    # Git & project management
    git
    ghq
    lazygit
    delta

    # Network & data
    curl
    wget

    # System tools
    htop
    vivid
    direnv

    # Miscellaneous utilities
    fixjson
    shellcheck
    actionlint
    worktrunk

    # Package Managers
    nodejs_24
    pnpm
    uv
  ];
}
