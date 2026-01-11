# Dotfiles

Personal dotfiles for Linux and macOS, featuring a modern Neovim setup with LSP support.

## Structure

```
dotfiles/
├── .bashrc                 # Bash configuration
├── .profile                # Shell profile
├── .config/
│   ├── fish/
│   │   └── config.fish     # Fish shell configuration
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
│               └── editor.lua       # File explorer, git, etc.
├── scripts/
│   └── utils.sh            # Common utility functions
├── install.sh              # Installation script
├── install_rust.sh         # Rust installation script
├── install_go.sh           # Go installation script
├── install_node.sh         # Node.js installation script (via nvm)
├── install_uv.sh           # uv (Python package manager) installation script
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

### Install Rust

```bash
./install_rust.sh
```

### Install Go

```bash
./install_go.sh
```

### Install Node.js (via nvm)

```bash
./install_node.sh
```

### Install uv (Python package manager)

```bash
./install_uv.sh
```

## Neovim Setup

### Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Support**: Rust, TypeScript/JavaScript, Python, C/C++, Lua
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

#### Window Management

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |

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

## Requirements

- Git
- curl / wget
- (Linux) sudo access for system packages
- (macOS) Homebrew (auto-installed if missing)

## License

MIT
