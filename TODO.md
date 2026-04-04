# TODO: dotfiles Nix 移行 & ディレクトリ再構成

mise ベースの開発環境管理を Nix (home-manager + nix-darwin) に移行し、ディレクトリ構成を ryoppippi/dotfiles を参考にリファクタする。

## 決定事項

- **Shell**: fish 一本。bash/zsh は必要になったら追加する
- **Neovim**: 生 lua ファイルのまま管理 (nixvim は使わない)
- **tmux**: Nix の `programs.tmux` で宣言的に管理する
- **Scala (coursier, Metals)**: 削除。C/C++ の LSP 設定も削除
- **対象言語**: Go + Rust + TypeScript + Python
- **言語ツールチェイン (Go, Rust, Node)**: グローバルには入れない
  - プロジェクトごとに `flake.nix` の `devShells` で定義する
  - `direnv` + `nix-direnv` で `cd` 時に自動アクティベート
- **グローバルに入れるもの (home-manager)**: エディタ・CLI ツールのみ
  - neovim, ripgrep, fd, fzf, bat, starship, ghq, yazi, lazygit, gh, direnv

## 目標とするディレクトリ構成

```
dotfiles/
├── flake.nix               # Nix エントリーポイント
├── flake.lock
├── nix/
│   └── modules/
│       ├── home/           # クロスプラットフォーム (home-manager)
│       │   ├── default.nix
│       │   ├── packages.nix    # CLI ツール群 (グローバル)
│       │   ├── direnv.nix      # direnv + nix-direnv 設定
│       │   ├── fish.nix
│       │   ├── git.nix
│       │   ├── starship.nix
│       │   └── tmux.nix
│       ├── darwin/         # macOS 専用 (nix-darwin)
│       │   └── default.nix
│       └── linux/          # Linux 専用
│           └── default.nix
├── fish/                   # Fish shell config (生ファイル)
│   └── config.fish
├── nvim/                   # Neovim config (生ファイル)
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── config/
│       └── plugins/
├── CLAUDE.md
├── TODO.md
├── README.md
└── LICENSE
```

注: tmux は `programs.tmux` で管理するため生ファイルのディレクトリは不要。

## タスク一覧

### Phase 1: Nix 基盤の導入

- [ ] Nix をインストール (Determinate Nix Installer 推奨)
- [ ] `flake.nix` を作成 (inputs: nixpkgs, home-manager, nix-darwin)
- [ ] `nix/modules/home/default.nix` を作成 — home-manager のエントリーポイント
- [ ] `nix/modules/home/packages.nix` を作成 — グローバル CLI ツール群
  - neovim, ripgrep, fd, fzf, bat, starship, ghq, yazi, lazygit, gh
  - uv (Python), tree-sitter CLI
- [ ] `nix/modules/home/direnv.nix` を作成 — direnv + nix-direnv (mise の代替)
- [ ] `nix/modules/darwin/default.nix` を作成 — macOS 固有設定 (nix-darwin)
- [ ] `nix/modules/linux/default.nix` を作成 — Linux 固有設定

### Phase 2: ディレクトリ再構成

- [ ] `.config/nvim/` → `nvim/` に移動
- [ ] `.config/fish/` → `fish/` に移動
- [ ] `.config/mise/config.toml` を削除 (Nix に役割を移譲)
- [ ] `.tmux.conf` を削除 (programs.tmux に移行)
- [ ] `.bashrc`, `.profile` を削除 (fish 一本化)
- [ ] シンボリンクの管理を home-manager の `xdg.configFile` / `home.file` に移行

### Phase 3: home-manager でドットファイルを宣言的に管理

- [ ] `nix/modules/home/fish.nix` — `programs.fish` で管理 + `fish/` 内の生ファイルをソース
- [ ] `nix/modules/home/git.nix` — git ユーザー設定
- [ ] `nix/modules/home/starship.nix` — starship 設定
- [ ] `nix/modules/home/tmux.nix` — `.tmux.conf` の内容を `programs.tmux` に移植
- [ ] nvim config は `xdg.configFile."nvim".source` で `nvim/` を丸ごとリンク

### Phase 4: Neovim 設定の整理

- [ ] `lua/plugins/metals.lua` を削除 (Scala 不要)
- [ ] `lua/plugins/lsp.lua` から C/C++ の LSP 設定を削除
- [ ] LSP 対象を Go (gopls), Rust (rust-analyzer), TypeScript (ts_ls) に絞る

### Phase 5: クリーンアップ

- [ ] `install.sh`, `install_clipboard.sh`, `install_coursier.sh` を削除
- [ ] `scripts/` ディレクトリを削除 (不要なら)
- [ ] `README.md` を更新 — Nix ベースのインストール手順に書き換え
- [ ] `.gitignore` を更新

### 補足: プロジェクトごとの devShell テンプレート

各プロジェクトで使う `flake.nix` の雛形 (dotfiles 外、参考用):

```nix
# Go プロジェクトの例
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { nixpkgs, ... }:
    let pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.go_1_22 pkgs.gopls pkgs.golangci-lint ];
      };
    };
}
```

`direnv` の `.envrc` に `use flake` と書くだけで `cd` 時に自動で環境が立ち上がる。
