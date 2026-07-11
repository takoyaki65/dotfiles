{ pkgs, lib, config, ... }:

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
      nixd
      pyright
      rust-analyzer
      typescript-language-server
      gopls

      # Formatters & linters
      stylua
    ];
  };

  # HM always generates an init.lua (provider disabling only), which would
  # conflict with the whole-directory symlink below; the repo config is the
  # source of truth (providers are disabled in lua/config/options.lua)
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  # Link raw lua config directly into the repo working tree (mutable,
  # edits and lazy-lock.json updates apply without a rebuild)
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/config/nvim";
}
