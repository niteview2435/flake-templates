# LuaLaTeX 開発環境 (Apple Silicon Mac / direnv)

このリポジトリは、**Nix Flakes** と **direnv** を活用した、Apple Silicon Mac (`aarch64-darwin`) 向けの LuaLaTeX（日本語）執筆環境です。

## 特徴

* **Mac への最適化**: `aarch64-darwin` 向けに構成されており、Apple Silicon 環境で即座に動作します。
* **direnv 連携**: ディレクトリに移動するだけで、コンパイラ、LSP (`texlab`)、各種環境変数が自動的にロードされます。
* **設定の自動展開**: Nix が管理する `.latexmkrc` がプロジェクト直下に自動でリンクされ、LuaLaTeX によるビルドが即座に可能です。
* **充実した日本語・理数パッケージ**: `luatexja` をはじめ、`physics2` や `tcolorbox` など、現代的な文書作成に必要なパッケージが同梱されています。

## 前提条件

* **Nix**: パッケージマネージャがインストールされていること。
* **direnv**: インストール済みであること。

## セットアップ

### 1. `.envrc` の作成
プロジェクトのルートディレクトリで以下のコマンドを実行し、Nix 環境の自動ロードを有効にします。

```bash
echo "use flake" > .envrc
direnv allow
```

### 2. ファイルの確認
環境がロードされると、Nix ストア内の設定ファイルを参照する `.latexmkrc` がカレントディレクトリに自動生成（シンボリックリンク）されます。

## 使い方

### 文書のビルド
環境がロードされた状態で以下のコマンドを実行してください。`.latexmkrc` の設定に従い、最適な回数だけ LuaLaTeX が実行されます。

```bash
latexmk document.tex
```

### LSP (Language Server)
`texlab` がパスに含まれているため、`direnv` に対応したエディタ（VSCode, Neovim, Zed 等）であれば、特別な設定なしに補完やエラーチェックが機能します。

## 構成詳細

### 搭載パッケージ
主要なパッケージは以下の通りです。

| カテゴリ | パッケージ |
| :--- | :--- |
| **日本語** | `luatexja`, `collection-langjapanese` |
| **数学・物理** | `amsmath`, `physics`, `physics2`, `amsmath`, `amsfonts` |
| **描画** | `pgf (TikZ)`, `tcolorbox`, `tikzfill` |
| **汎用** | `geometry`, `hyperref`, `latexmk`, `xcolor`, `titlesec` |

### 環境変数
`direnv` を通じて以下の変数が自動でエクスポートされます。

* **`PRJ_ROOT`**: プロジェクトのルートパス。
* **`TEXINPUTS`**: プロジェクト内のファイルを再帰的に検索対象に含める設定（`.:$PRJ_ROOT//:`）。

## 注意事項

* 本環境は `aarch64-darwin` 専用です。Intel Mac や Linux 環境で利用する場合は、`flake.nix` 内の `system` 変数を修正してください。
* `.latexmkrc` は `nix develop` (または `direnv`) 実行時に上書き（再リンク）されます。手動で編集する必要がある場合は、`flake.nix` 内の `latexmkrc` 変数を修正してください。
