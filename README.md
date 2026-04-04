# Dotfiles

Personal dotfiles for macOS and Linux, managed with [Nix](https://nixos.org/) (home-manager + nix-darwin).

## Structure

```
dotfiles/
├── flake.nix               # Nix entry point
├── nix/modules/
│   ├── home/               # Cross-platform (home-manager)
│   │   ├── default.nix     # Entry point — imports all modules
│   │   ├── packages.nix    # CLI tools (neovim, ripgrep, fd, etc.)
│   │   ├── direnv.nix      # direnv + nix-direnv
│   │   ├── fish.nix        # Fish shell
│   │   ├── git.nix         # Git config
│   │   ├── starship.nix    # Starship prompt
│   │   └── tmux.nix        # tmux (programs.tmux)
│   ├── darwin/             # macOS (nix-darwin)
│   └── linux/              # Linux
├── fish/                   # Fish shell config (raw files)
├── nvim/                   # Neovim config (raw lua files)
│   ├── init.lua
│   └── lua/
│       ├── config/         # options, keymaps, lazy.nvim bootstrap
│       └── plugins/        # plugin specs
├── TODO.md
├── README.md
└── LICENSE
```

## Installation

### Prerequisites

Install Nix via [Determinate Nix Installer](https://determinate.systems/nix-installer/):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Clone

```bash
git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### macOS

```bash
nix run nix-darwin -- switch --flake .#mizokami
```

After the first run:

```bash
darwin-rebuild switch --flake .#mizokami
```

### Linux

```bash
nix run home-manager -- switch --flake .#mizokami
```

After the first run:

```bash
home-manager switch --flake .#mizokami
```

## Dev environments

Language toolchains (Go, Rust, Node, Python) are not installed globally. Each project defines its own `flake.nix` with a `devShell`:

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.go_1_23 pkgs.gopls ];
        };
      });
    };
}
```

Add `use flake` to the project's `.envrc` and `direnv` will activate the environment on `cd`.

## Neovim

- **Plugin Manager**: lazy.nvim
- **LSP**: Go (gopls), Rust (rust-analyzer), TypeScript (ts_ls), Python (pyright), Lua (lua_ls)
- **AI**: GitHub Copilot
- **Fuzzy Finder**: Telescope + ghq
- **File Explorer**: oil.nvim + yazi.nvim
- **Theme**: Tokyo Night

## License

MIT
