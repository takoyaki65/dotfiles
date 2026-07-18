{ llmAgents, ... }:

{
    home.packages = with llmAgents; [
        codex
        claude-code
    ];
}
