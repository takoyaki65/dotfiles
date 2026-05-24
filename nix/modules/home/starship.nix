{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
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
