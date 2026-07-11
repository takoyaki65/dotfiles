{ pkgs, config, ... }:

{
  # programs.starship is intentionally OFF: fish init is done via the config cache in
  # config/fish/config.fish instead.
  home.packages = [ pkgs.starship ];

  # starship.toml lives in the repo; edits apply without a rebuild.
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/starship.toml";
}
