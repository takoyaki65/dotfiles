# TODO: GitHub Actions CI の拡充

nix-build + lint の基本 CI は導入済み。以下は今後対応する項目。

## Flake input の自動更新 (遅延付き)

- [ ] GitHub App を作成し、bot identity で自動 PR を作れるようにする
- [ ] `update-flake-input` composite action を作成 — input 単位で更新 + `minimumReleaseAge` チェック (3日)
- [ ] `discover-flake-inputs` composite action を作成 — flake.lock から input を列挙し matrix 生成
- [ ] `_update-flake-reusable.yaml` — 上記を組み合わせた reusable workflow
- [ ] `update-flake.yaml` — 日次 cron で stable input を更新 (3日遅延)
- [ ] 自動更新 PR のビルドが通ったら auto-merge (squash) する仕組み
- [ ] `auto-rebase.yaml` — main 更新時に open 中の update PR を自動リベース

## Renovate の導入

- [ ] `.github/renovate.json5` を作成 — GitHub Actions の SHA ピン留めを自動更新
  - `minimumReleaseAge: '3 days'` を設定
  - `nix.enabled: false` (flake input は上記の独自 workflow で管理)
- [ ] `renovate-config-validator.yaml` — Renovate 設定の lint CI

## Nix Diff (PR レビュー支援)

- [ ] `nix-diff.yaml` — PR で flake.lock / nix/** が変わった時にパッケージ差分をコメント表示
  - `natsukium/nix-diff-action` を利用

## フォーマッタの導入

- [ ] flake に `treefmt-nix` or `nixfmt` を追加し、`nix fmt` で統一フォーマット
- [ ] lint CI にフォーマットチェックステップを追加 (`nix run .#fmt -- --fail-on-change`)
