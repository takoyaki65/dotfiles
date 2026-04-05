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
    yazi
    tree-sitter

    # Git & project management
    gh
    ghq
    lazygit

    # Python
    uv
  ];
}
