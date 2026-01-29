# Dotfiles

Personal dotfiles for Linux and macOS, featuring Neovim + tmux workflow with LSP support. Dev tools are managed by [mise](https://mise.jdx.dev/).

## Structure

```
dotfiles/
├── .bashrc                 # Bash configuration
├── .profile                # Shell profile
├── .tmux.conf              # tmux configuration
├── .config/
│   ├── fish/
│   │   └── config.fish     # Fish shell configuration
│   ├── mise/
│   │   └── config.toml     # mise tool versions (Node, Go, Rust, etc.)
│   └── nvim/
│       ├── init.lua        # Neovim entry point
│       └── lua/
│           ├── config/
│           │   ├── options.lua   # Editor options
│           │   ├── keymaps.lua   # Key bindings
│           │   └── lazy.lua      # Plugin manager bootstrap
│           └── plugins/
│               ├── colorscheme.lua  # Tokyo Night theme
│               ├── ui.lua           # Statusline, bufferline, etc.
│               ├── telescope.lua    # Fuzzy finder
│               ├── treesitter.lua   # Syntax highlighting
│               ├── lsp.lua          # LSP & completion
│               ├── metals.lua       # Scala LSP (Metals)
│               └── editor.lua       # File explorer, git, etc.
├── scripts/
│   └── utils.sh            # Common utility functions
├── install.sh              # Installation script
├── install_clipboard.sh    # Clipboard integration script
├── install_coursier.sh     # Coursier (Scala) installation script
└── LICENSE
```

## Installation

### Quick Install (All Components)

```bash
git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --all
```

### Interactive Install

```bash
./install.sh
```

This will prompt you to select which components to install:
- System packages (ripgrep, fd, etc.)
- Neovim
- Symlinks
- Git configuration

### Dev Tools (via mise)

Development tools (Node.js, Go, Rust, uv, etc.) are managed by [mise](https://mise.jdx.dev/). See `.config/mise/config.toml` for the configured tool versions.

```bash
mise install
```

## Neovim Setup

### Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Support**: Rust, TypeScript/JavaScript, Python, C/C++, Lua, Scala (Metals)
- **Fuzzy Finder**: Telescope
- **Syntax Highlighting**: Treesitter
- **File Explorer**: Neo-tree
- **Theme**: Tokyo Night

### Key Bindings

Leader key: `Space`

#### File Navigation

| Key | Description |
|-----|-------------|
| `<C-p>` | Find files |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle file explorer |

#### LSP

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>fm` | Format |
| `[d` / `]d` | Previous/Next diagnostic |

#### Window/Pane Navigation (via tmux)

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate between tmux panes and Neovim windows seamlessly |

Pane splitting is handled by tmux (`prefix + |` for vertical, `prefix + -` for horizontal).

#### Buffer Navigation

| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |

#### Git

| Key | Description |
|-----|-------------|
| `]h` / `[h` | Next/Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

#### Other

| Key | Description |
|-----|-------------|
| `<C-\>` | Toggle terminal |
| `<leader>?` | Show keybindings |
| `gc` | Toggle comment (visual mode) |

### First Launch

On first launch, Neovim will automatically:
1. Install lazy.nvim plugin manager
2. Download and install all plugins
3. Install LSP servers via Mason

Run `:Mason` to manage LSP servers manually.

## tmux Setup

Prefix key: `C-a`

| Key | Description |
|-----|-------------|
| `prefix + \|` | Vertical split |
| `prefix + -` | Horizontal split |
| `C-h/j/k/l` | Navigate panes (integrated with Neovim via vim-tmux-navigator) |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + z` | Zoom pane toggle |
| `prefix + v` | Enter copy mode (vi-style) |
| `prefix + r` | Reload config |

## Requirements

- Git
- curl / wget
- (Linux) sudo access for system packages
- (macOS) Homebrew (auto-installed if missing)

## License

MIT
