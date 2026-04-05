{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      username = {
        show_always = true;
      };
      hostname = {
        ssh_only = false;
      };
    };
  };
}
