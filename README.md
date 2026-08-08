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

Choose the instructions for the target platform and architecture.

<details>
<summary>macOS</summary>

`curl` is assumed to be available. Homebrew is required for casks and Mac App
Store apps. Since Git is not installed by default, the repository is cloned
with Git from Nix.

```bash
# Install Nix.
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install Homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repository.
nix shell nixpkgs#git -c git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Apply the nix-darwin configuration for the first time.
sudo "$(command -v nix)" run nix-darwin -- switch --flake .#mizokami

# Reload the shell.
exec fish
```

After subsequent configuration changes, run
`sudo darwin-rebuild switch --flake .#mizokami`.

</details>

<details>
<summary>Linux (aarch64)</summary>

The first switch takes ownership of `/etc/nix/nix.conf`; system-manager keeps
the original as a backup. Home Manager backs up pre-existing dotfiles with the
`.backup` extension.

```bash
# Install Nix.
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Clone this repository with Git from Nix.
nix shell nixpkgs#git -c git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Apply both the system-manager and Home Manager configurations.
# Run this command again after subsequent configuration changes.
sudo "$(command -v nix)" --accept-flake-config run .#system-manager -- \
  --nix-option accept-flake-config true \
  switch --flake .#mizokami-aarch64
```

</details>

<details>
<summary>Linux (non-aarch64)</summary>

The first switch takes ownership of `/etc/nix/nix.conf`; system-manager keeps
the original as a backup. Home Manager backs up pre-existing dotfiles with the
`.backup` extension.

```bash
# Install Nix.
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Clone this repository with Git from Nix.
nix shell nixpkgs#git -c git clone https://github.com/takoyaki65/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Apply both the system-manager and Home Manager configurations.
# Run this command again after subsequent configuration changes.
sudo "$(command -v nix)" --accept-flake-config run .#system-manager -- \
  --nix-option accept-flake-config true \
  switch --flake .#mizokami
```

</details>

## Neovim

- **Plugin Manager**: lazy.nvim
- **LSP**: Go (gopls), Rust (rust-analyzer), TypeScript (ts_ls), Python (pyright), Lua (lua_ls)
- **AI**: GitHub Copilot
- **Fuzzy Finder**: Telescope + ghq
- **File Explorer**: oil.nvim + yazi.nvim
- **Theme**: Tokyo Night

## License

MIT
