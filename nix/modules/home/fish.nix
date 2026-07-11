{ config, pkgs, ... }:

{
  # Keep enabled: HM's generated config.fish sources hm-session-vars
  # (essential on standalone Linux HM) and carries integrations such as
  # starship's enableFishIntegration.
  programs.fish.enable = true;

  # Raw fish config lives in the repo; edits apply without a rebuild.
  # fish auto-sources conf.d/*.fish (before config.fish) and autoloads functions/.
  xdg.configFile."fish/conf.d".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish/conf.d";
  xdg.configFile."fish/functions".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish/functions";

  home.packages = with pkgs; [
    trash-cli
  ];
}
