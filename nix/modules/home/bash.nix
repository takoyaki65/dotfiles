{ config, ... }:

{
  # Plain bash configs live in config/bash/ and are linked out-of-store,
  # so edits apply without a rebuild (same pattern as fish/starship).
  home.file.".bashrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/bash/bashrc";
  home.file.".bash_profile".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/bash/bash_profile";
}
