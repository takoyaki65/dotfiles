{ config, ... }:

{
  xdg.configFile."shell/hm-session.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/shell/hm-session.sh";
}
