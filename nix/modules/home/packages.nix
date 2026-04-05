{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    neovim

    # Terminal (Ghostty is installed via Homebrew on macOS)

    # Search & file utils
    ripgrep
    fd
    fzf
    bat
    eza
    yazi
    tree-sitter
    dust
    zoxide

    # Git & project management
    git
    gh
    ghq
    lazygit
    delta

    # Network & data
    curl
    jq

    # System tools
    tmux
    htop
    vivid
    direnv

    # Shell
    shellcheck

    # Python
    uv
  ];
}
