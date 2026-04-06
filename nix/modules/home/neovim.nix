{ pkgs, dotfilesDir, ... }:

let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
in
{
  programs.neovim = {
    enable = true;

    # Pass Nix-built tree-sitter grammars via environment variable
    extraWrapperArgs = [
      "--set" "TREESITTER_GRAMMARS" "${treesitterGrammars}"
    ];

    # LSP servers and tools — available only in Neovim's PATH
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      pyright
      rust-analyzer
      typescript-language-server
      gopls

      # Formatters & linters
      stylua
    ];
  };

  # Link raw lua config as-is
  xdg.configFile."nvim".source = "${dotfilesDir}/nvim";
}
