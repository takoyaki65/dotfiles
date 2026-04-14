{
  pkgs,
  lib,
  config,
  ...
}:
let
  ghosttySettings = {
    font-family = "UDEV Gothic 35LG";
    font-size = 13;
    font-feature = [ "-dlig" ];

    background-opacity = 0.90;
    background-blur-radius = 20;

    theme = "Kanagawa Dragon";

    shell-integration = "fish";
    shell-integration-features = "no-cursor";

    cursor-style = "block";
    cursor-style-blink = false;

    mouse-hide-while-typing = true;

    working-directory = "inherit";
  };
in
{
  # On macOS, Ghostty is installed via Homebrew, so we just generate the config file.
  # On Linux, use the full programs.ghostty module.
  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = pkgs.ghostty;
    enableFishIntegration = true;
    settings = ghosttySettings;
  };

  xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
    text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value:
        if builtins.isList value then
          lib.concatMapStringsSep "\n" (v: "${name} = ${toString v}") value
        else if builtins.isBool value then
          "${name} = ${if value then "true" else "false"}"
        else
          "${name} = ${toString value}"
      ) ghosttySettings
    );
  };

  # Ghostty on macOS looks for config in Application Support.
  # Symlink our XDG config there so both paths resolve to the same file.
  home.activation.linkGhosttyConfig = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      $DRY_RUN_CMD rm -rf "${config.home.homeDirectory}/Library/Application Support/com.mitchellh.ghostty/config"
      $DRY_RUN_CMD ln -sf "${config.xdg.configHome}/ghostty/config" "${config.home.homeDirectory}/Library/Application Support/com.mitchellh.ghostty/config"
    ''
  );
}
