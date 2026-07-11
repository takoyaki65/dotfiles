{ lib, config, ... }:

{
  options.dotfiles.path = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/dotfiles";
    description = ''
      Absolute path (string, outside the Nix store) to the dotfiles
      working tree. Used with mkOutOfStoreSymlink for mutable configs.
    '';
  };
}
