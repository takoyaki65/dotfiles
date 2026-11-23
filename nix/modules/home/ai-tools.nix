{ pkgs, config, llmAgents, ... }:

{
  home.packages = [
    llmAgents.codex
    llmAgents.claude-code
    (pkgs.callPackage ../../packages/jevlint { })
  ];

  xdg.configFile."jevlint/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/jevlint/config.toml";

  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/codex/AGENTS.md";
}
