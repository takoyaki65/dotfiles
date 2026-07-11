{ pkgs, config, ... }:

{
  home.packages = [ pkgs.zsh ];

  home.file.".zshrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/zsh/zshrc";
}
