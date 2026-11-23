{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.ghostty = {
    enable = true;
    # Homebrew installs Ghostty on macOS; Home Manager only generates its config.
    package = if isDarwin then null else pkgs.ghostty;

    # macOS uses Ghostty's automatic shell integration.
    enableBashIntegration = !isDarwin;
    enableFishIntegration = !isDarwin;
    enableZshIntegration = !isDarwin;

    settings = {
      font-family = "UDEV Gothic 35LG";
      font-size = 13;
      font-feature = [ "-dlig" ];

      background-opacity = 0.90;
      background-blur-radius = 20;

      theme = "Kanagawa Dragon";

      # Pin the shell to this generation's fish package.
      command = "${pkgs.fish}/bin/fish";

      shell-integration = "fish";
      shell-integration-features = "no-cursor";

      cursor-style = "block";
      cursor-style-blink = false;

      mouse-hide-while-typing = true;

      working-directory = "home";
    };
  };
}
