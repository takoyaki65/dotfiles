# Dotfiles

Personal dotfiles for macOS and Linux, managed with [Nix](https://nixos.org/) (home-manager + nix-darwin).

## Structure

```
dotfiles/
├── flake.nix               # Nix entry point
├── nix/modules/
│   ├── home/               # Cross-platform (home-manager)
│   ├── darwin/             # macOS (nix-darwin)
│   └── linux/              # Linux
├── config/                 # Raw config files (the working tree is the source of truth)
│   ├── nvim/               # Neovim config (raw lua files, symlinked out-of-store)
│   ├── fish/               # fish conf.d/functions (symlinked out-of-store)
│   └── karabiner/          # Karabiner-Elements config
├── README.md
└── LICENSE
```

`config/nvim` and `config/fish` are linked into `~/.config` with
`mkOutOfStoreSymlink`, so edits (including lazy.nvim's `lazy-lock.json`
updates) take effect immediately without a rebuild — remember to commit
them afterwards.

## Installation

### macOS

1. Install [Nix](https://github.com/NixOS/nix-installer):

   We assume `curl` is installed by default.
   ```bash
   curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
   ```

2. Install [Homebrew](https://brew.sh/) (required for casks and Mac App Store apps):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Clone this repository:

   `git` is not installed by default, so use git from `nix-shell`.
   ```bash
   nix shell nixpkgs#git -c git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
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

After the first run, run this command to sync your environment with this config.

```bash
sudo darwin-rebuild switch --flake .#mizokami
```

### Linux

1. Install [Nix](https://github.com/NixOS/nix-installer):

   ```bash
   curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
   ```

2. Clone this repository with Git from Nix:

   ```bash
   nix shell nixpkgs#git -c git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. Apply the system-manager and Home Manager configuration:

   ```bash
   sudo nix --accept-flake-config run .#system-manager -- \
     switch --flake .#mizokami
   ```

   Use `.#mizokami-aarch64` instead on an AArch64 machine. The first switch
   also takes ownership of `/etc/nix/nix.conf`; the original is retained as a
   system-manager backup.

Run the same command after the first switch to sync both the system and home
configuration. Home Manager backs up pre-existing dotfiles with the `.backup`
extension.

```bash
sudo nix --accept-flake-config run .#system-manager -- \
  switch --flake .#mizokami
```

## Neovim

- **Plugin Manager**: lazy.nvim
- **LSP**: Go (gopls), Rust (rust-analyzer), TypeScript (ts_ls), Python (pyright), Lua (lua_ls)
- **AI**: GitHub Copilot
- **Fuzzy Finder**: Telescope + ghq
- **File Explorer**: oil.nvim + yazi.nvim
- **Theme**: Tokyo Night

## License

MIT
