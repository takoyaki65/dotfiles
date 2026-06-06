{
  dotfilesDir,
  lib,
  pkgs,
  ...
}:

{
  home.activation.restartKarabinerBeforeConfig = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryBefore [ "linkGeneration" ] ''
      if /bin/launchctl list | ${lib.getExe pkgs.gnugrep} -q "org.pqrs.service.agent.karabiner_console_user_server"; then
        echo "Restarting Karabiner console user server before config update..."
        /bin/launchctl kickstart -k gui/$(/usr/bin/id -u)/org.pqrs.service.agent.karabiner_console_user_server 2>/dev/null || true
        sleep 2
      fi
    ''
  );

  # macOS-specific dotfile symlinks
  xdg.configFile."karabiner/karabiner.json".source = "${dotfilesDir}/karabiner/karabiner.json";
}
