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

      # ~/.local/bin (claude, etc.)
      fish_add_path -g $HOME/.local/bin

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
