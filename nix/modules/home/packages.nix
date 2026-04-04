{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    neovim

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
