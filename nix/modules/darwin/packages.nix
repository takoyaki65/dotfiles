{ pkgs, ... }:

{
  # macOS-specific Nix packages (home-manager)
  home.packages = with pkgs; [
    mas
  ];
}
