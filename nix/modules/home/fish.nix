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
    '';
  };

  home.packages = with pkgs; [
    trash-cli
  ];
}
