{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    neovim

    # Terminal
    (if pkgs.stdenv.isDarwin then ghostty-bin else ghostty)

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
