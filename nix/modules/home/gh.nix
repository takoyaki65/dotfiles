{ pkgs, ... }:

{
  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
      };
    };

    extensions = [
      pkgs.gh-markdown-preview
    ];
  };
}
