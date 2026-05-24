{ pkgs, ... }:

{
    home.packages = with pkgs.llm-agents; [
        codex
        claude-code
    ];
}
