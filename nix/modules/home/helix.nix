{ config, ... }:

{
  xdg.configFile."helix".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/helix";
}
