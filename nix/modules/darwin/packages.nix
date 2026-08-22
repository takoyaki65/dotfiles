{ pkgs, ... }:

let
  utmctl = pkgs.writeShellScriptBin "utmctl" ''
    exec /Applications/UTM.app/Contents/MacOS/utmctl "$@"
  '';
in

{
  # macOS-specific Nix packages (home-manager)
  home.packages = with pkgs; [
    mas
    keycastr
    utmctl
  ];
}
