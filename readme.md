# latex-indentが機能しないとき
[参考](https://zenn.dev/ganariya/articles/vscode-latex-indent)

```
$ sudo apt install cpanminus
```
でPerlのパッケージマネージャ？であるcpanmをインストール

その後、``latexindent main.tex``を実行してエラー文を読みつつ、足りないパッケージをインストールしたら動作できた。
```
$ sudo cpanm YAML::Tiny
$ sudo cpanm File::HomeDir
$ sudo cpanm Unicode::GCString
```