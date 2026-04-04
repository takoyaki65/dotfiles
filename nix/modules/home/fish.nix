{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      del = "trash";
      delete = "trash";
    };
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Homebrew
      if test -x /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv fish)"
      end
    '';
  };

  home.packages = with pkgs; [
    trash-cli
  ];
}
