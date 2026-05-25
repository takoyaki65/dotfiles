{ ... }:

{
  programs.bash = {
    enable = true;
    # Bash is the default login shell (set by chsh on /etc/passwd).
    # But we want to use fish shell, so we add initial scripts to load fish shell.
    # ref: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    initExtra = ''
      if [[ $(ps -p $PPID -o comm=) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec fish $LOGIN_OPTION
      fi
    '';
  };
}
