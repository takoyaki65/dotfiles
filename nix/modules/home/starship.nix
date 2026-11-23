{ pkgs, config, ... }:

{
  # programs.starship is intentionally OFF: config/fish/config.fish initializes it.
  home.packages = [ pkgs.starship ];

  # starship.toml lives in the repo; edits apply without a rebuild.
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/starship.toml";
}
