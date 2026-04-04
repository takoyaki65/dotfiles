{ ... }:

{
  programs.git = {
    enable = true;
    settings.user.name = "Takuya Mizokami";
    settings.user.email = "takoyaki65@users.noreply.github.com";
    signing.format = null;
  };
}
