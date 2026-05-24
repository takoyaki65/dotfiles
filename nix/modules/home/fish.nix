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

      # Nerd Fonts (UDEV Gothic NF) for themes/prompts
      set -gx theme_nerd_fonts yes

      # LS_COLORS via vivid
      set -gx LS_COLORS (vivid generate tokyonight-night)

      # macOS: Homebrew & SSH SK provider
      if test (uname) = Darwin
        if test -x /opt/homebrew/bin/brew
          eval "$(/opt/homebrew/bin/brew shellenv fish)"
        end
        set -gx SSH_SK_PROVIDER /usr/lib/ssh-keychain.dylib
      end
    '';
  };

  home.packages = with pkgs; [
    trash-cli
  ];
}
