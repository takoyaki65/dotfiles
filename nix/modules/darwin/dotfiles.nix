{ dotfilesDir, ... }:

{
  # macOS-specific dotfile symlinks
  xdg.configFile."karabiner/karabiner.json".source = "${dotfilesDir}/karabiner/karabiner.json";
}
