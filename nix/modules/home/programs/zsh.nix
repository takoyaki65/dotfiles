{ ... }:

{
  programs.zsh = {
    enable = true;
    # Zsh is the login shell, but we want interactive login shells to run fish.
    # Keep zsh as the system login shell and replace it with fish for normal use.
    initContent = ''
      if [[ $(ps -p $PPID -o comm=) != "fish" && -o login && -z ''${ZSH_EXECUTION_STRING} ]]
      then
        exec fish --login
      fi
    '';
  };
}
