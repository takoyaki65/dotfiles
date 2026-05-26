{ ... }:

{
  programs.bash = {
    enable = true;
    # Bash is the default login shell (set by chsh on /etc/passwd).
    # But we want to use fish shell for login shells, so we replace login bash with fish.
    # ref: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    initExtra = ''
      if [[ $(ps -p $PPID -o comm=) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] && shopt -q login_shell
      then
        exec fish --login
      fi
    '';
  };
}
