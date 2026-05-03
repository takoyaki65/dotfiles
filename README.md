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
├── README.md
└── LICENSE
```

## Installation

### macOS

1. Install [Nix](https://github.com/NixOS/nix-installer):

   ```bash
   curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
   ```

2. Install [Homebrew](https://brew.sh/) (required for casks and Mac App Store apps):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Clone this repository:

   ```bash
   git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

4. Apply the nix-darwin configuration (initial run):

   ```bash
   sudo nix run nix-darwin -- switch --flake .#mizokami
   ```

5. Reload your shell:

   ```bash
   exec fish
   ```

After the first run, use:

```bash
darwin-rebuild switch --flake .#mizokami
```

### Linux

1. Install [Nix](https://github.com/NixOS/nix-installer):

   ```bash
   curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
   ```

2. Clone this repository:

   ```bash
   git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. Apply Home Manager configuration:

   ```bash
   nix run home-manager -- switch --flake .#mizokami
   ```

After the first run, use:

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

## Scripts

### update-flake-delayed

Flake input を「最低 N 日経過したコミット」に更新するスクリプト。zero-day 攻撃やリリース直後の不具合を避けるために、最新を即座に取り込まず遅延させる。

```bash
# nixpkgs を3日以上前のコミットに更新 (デフォルト)
./scripts/update-flake-delayed nixpkgs NixOS nixpkgs nixpkgs-unstable

# home-manager を7日遅延で更新
./scripts/update-flake-delayed -d 7 home-manager nix-community home-manager

# dry-run で確認だけ
./scripts/update-flake-delayed --dry-run nixpkgs NixOS nixpkgs nixpkgs-unstable
```

前提: `gh` (GitHub CLI) がインストール済みで認証されていること。

## Neovim

- **Plugin Manager**: lazy.nvim
- **LSP**: Go (gopls), Rust (rust-analyzer), TypeScript (ts_ls), Python (pyright), Lua (lua_ls)
- **AI**: GitHub Copilot
- **Fuzzy Finder**: Telescope + ghq
- **File Explorer**: oil.nvim + yazi.nvim
- **Theme**: Tokyo Night

## License

MIT
