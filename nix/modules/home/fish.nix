{ config, pkgs, ... }:

{
  # programs.fish.enable is intentionally OFF: home-manager would generate
  # ~/.config/fish/config.fish (hm-session-vars sourcing + tool integrations).
  # The repo's config/fish/config.fish handles both itself, so the whole fish
  # config stays editable without a rebuild.

  # The whole fish config dir is one out-of-store link; edits apply without a
  # rebuild. Runtime artifacts (fish_variables, OrbStack's completion symlinks)
  # therefore land in the repo's config/fish/ and are excluded via .gitignore.
  xdg.configFile."fish".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/fish";

  home.packages = with pkgs; [
    # On macOS nix-darwin installs fish system-wide; this covers standalone
    # home-manager on Linux where programs.fish.enable was the only source.
    fish
    trash-cli
  ];
}
