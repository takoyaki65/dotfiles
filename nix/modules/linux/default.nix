{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xclip
  ];

  # SSH preserves Ghostty's TERM value, but remote ncurses applications need
  # Ghostty's terminfo database on their search path to interpret it.
  # The trailing colon keeps ncurses' default system terminfo directories.
  home.sessionVariables.TERMINFO_DIRS = "${pkgs.ghostty.terminfo}/share/terminfo:";
}
