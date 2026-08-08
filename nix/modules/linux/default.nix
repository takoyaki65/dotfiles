{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xclip
  ];

  # SSH preserves Ghostty's TERM value, but remote ncurses applications need
  # Ghostty's terminfo database on their search path to interpret it.
  # The trailing colon keeps ncurses' default system terminfo directories.
  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.ghostty.terminfo}/share/terminfo:";

    # Unlike TERM, SSH does not transmit COLORTERM as part of PTY allocation.
    # This Linux profile uses Ghostty, which supports true color.
    COLORTERM = "truecolor";
  };
}
