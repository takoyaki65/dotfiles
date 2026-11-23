{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.nixd ];

    languages.language = [
      {
        name = "nix";
        language-servers = [ "nixd" ];
      }
    ];
  };
}
