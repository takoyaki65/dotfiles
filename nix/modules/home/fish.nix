{ config, pkgs, ... }:

{
  # programs.fish.enable is intentionally OFF: home-manager would generate
  # ~/.config/fish/config.fish (hm-session-vars sourcing + tool integrations).
  # The repo's config/fish/config.fish handles both itself, so the whole fish
  # config stays editable without a rebuild.

  # Raw fish config lives in the repo; edits apply without a rebuild.
  # fish auto-sources conf.d/*.fish (before config.fish) and autoloads functions/.
  # The fish dir is NOT symlinked wholesale so fish_variables stays out of the repo.
  xdg.configFile."fish/config.fish".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish/config.fish";
  xdg.configFile."fish/conf.d".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish/conf.d";
  xdg.configFile."fish/functions".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish/functions";

  home.packages = with pkgs; [
    # On macOS nix-darwin installs fish system-wide; this covers standalone
    # home-manager on Linux where programs.fish.enable was the only source.
    fish
    trash-cli
  ];
}
