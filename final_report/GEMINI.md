# GEMINI.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
## rules
- 必ず日本語で返答すること
- 関数名や数字には\verb|Hoge|のようにverbで囲うこと
- 句読点は， "，" "．"を使用すること
- わからないことがあればユーザーに質問返しすること
- 新たに新しいルールをユーザーに命令された場合は，このルールに付け足すこと
- LaTeXファイルの編集後，コンパイルはユーザーが行うため，Claudeはコンパイルを実行しないこと
## Project Overview


**Language**: Japanese (all reports are written in Japanese)

**Student Information**:
- 学生番号: 09B54923549
- Name: 中嶋 空偉 (NAKAJIMA, Sorai)


## Building LaTeX Documents

### Standard compilation (Japanese LaTeX with bxjsarticle)

```bash
# Compile to DVI, then convert to PDF
platex main.tex
platex main.tex          # Run twice for cross-references and TOC
dvipdfmx main.dvi
```

### Alternative with uplatex

```bash
uplatex main.tex
uplatex main.tex
dvipdfmx main.dvi
```

### Quick one-liner

```bash
platex main.tex && platex main.tex && dvipdfmx main.dvi
```

### Clean auxiliary files

```bash
rm -f *.aux *.log *.dvi *.fls *.fdb_latexmk *.synctex.gz
```

## コンパイルテスト

### 基本的なコンパイルテスト

LaTeXファイルが正しくコンパイルできるかをテストするスクリプトです．

**test_compile.sh**:

```bash
#!/bin/bash

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "LaTeX Compilation Test"
echo "========================================="

# テスト対象ファイル
TEX_FILE="main.tex"

# ファイル存在チェック
if [ ! -f "$TEX_FILE" ]; then
    echo -e "${RED}[ERROR]${NC} $TEX_FILE が見つかりません"
    exit 1
fi

# クリーンアップ
echo -e "${YELLOW}[INFO]${NC} 古いビルド成果物をクリーンアップ中..."
rm -f *.aux *.log *.dvi *.pdf *.fls *.fdb_latexmk *.synctex.gz *.out *.toc

# 1回目のコンパイル
echo -e "${YELLOW}[INFO]${NC} 1回目のコンパイル中..."
if ! platex -halt-on-error "$TEX_FILE" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL]${NC} 1回目のコンパイルに失敗しました"
    echo -e "${YELLOW}[INFO]${NC} エラーログを確認してください："
    platex -halt-on-error "$TEX_FILE" 2>&1 | tail -20
    exit 1
fi
echo -e "${GREEN}[PASS]${NC} 1回目のコンパイル成功"

# 2回目のコンパイル（相互参照解決のため）
echo -e "${YELLOW}[INFO]${NC} 2回目のコンパイル中..."
if ! platex -halt-on-error "$TEX_FILE" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL]${NC} 2回目のコンパイルに失敗しました"
    platex -halt-on-error "$TEX_FILE" 2>&1 | tail -20
    exit 1
fi
echo -e "${GREEN}[PASS]${NC} 2回目のコンパイル成功"

# DVI to PDF変換
echo -e "${YELLOW}[INFO]${NC} PDF変換中..."
if ! dvipdfmx main.dvi > /dev/null 2>&1; then
    echo -e "${RED}[FAIL]${NC} PDF変換に失敗しました"
    dvipdfmx main.dvi
    exit 1
fi
echo -e "${GREEN}[PASS]${NC} PDF変換成功"

# PDFファイルの存在確認
if [ ! -f "main.pdf" ]; then
    echo -e "${RED}[FAIL]${NC} main.pdf が生成されませんでした"
    exit 1
fi

# PDFファイルサイズチェック（0バイトでないか）
PDF_SIZE=$(wc -c < "main.pdf")
if [ "$PDF_SIZE" -lt 1000 ]; then
    echo -e "${RED}[FAIL]${NC} PDFファイルサイズが小さすぎます（${PDF_SIZE} bytes）"
    exit 1
fi
echo -e "${GREEN}[PASS]${NC} PDFファイル生成成功（${PDF_SIZE} bytes）"

# 警告チェック（オプション）
echo -e "${YELLOW}[INFO]${NC} 警告をチェック中..."
WARNING_COUNT=$(grep -c "Warning" main.log 2>/dev/null || echo "0")
if [ "$WARNING_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}[WARN]${NC} $WARNING_COUNT 個の警告が見つかりました"
    grep "Warning" main.log | head -5
else
    echo -e "${GREEN}[PASS]${NC} 警告なし"
fi

# 未解決の相互参照チェック
UNDEFINED_REF=$(grep -c "Reference.*undefined" main.log 2>/dev/null || echo "0")
if [ "$UNDEFINED_REF" -gt 0 ]; then
    echo -e "${RED}[FAIL]${NC} 未解決の参照が $UNDEFINED_REF 個あります"
    grep "Reference.*undefined" main.log
    exit 1
fi
echo -e "${GREEN}[PASS]${NC} すべての相互参照が解決されています"

echo "========================================="
echo -e "${GREEN}All tests passed!${NC}"
echo "========================================="
exit 0
```

### テストスクリプトの使用方法

```bash
# スクリプトに実行権限を付与
chmod +x test_compile.sh

# テストを実行
./test_compile.sh

# 終了コードを確認（0なら成功，1なら失敗）
echo $?
```

### CI/CDへの統合（GitHub Actions）

**.github/workflows/latex-compile.yml**:

```yaml
name: LaTeX Compilation Test

on:
  push:
    branches: [ main ]
    paths:
      - '**.tex'
      - 'images/**'
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Install LaTeX
      run: |
        sudo apt-get update
        sudo apt-get install -y texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra

    - name: Compile LaTeX
      run: |
        platex -halt-on-error main.tex
        platex -halt-on-error main.tex
        dvipdfmx main.dvi

    - name: Check PDF
      run: |
        if [ ! -f main.pdf ]; then
          echo "PDF not generated"
          exit 1
        fi
        PDF_SIZE=$(wc -c < main.pdf)
        if [ "$PDF_SIZE" -lt 1000 ]; then
          echo "PDF size too small: $PDF_SIZE bytes"
          exit 1
        fi
        echo "PDF generated successfully: $PDF_SIZE bytes"

    - name: Upload PDF artifact
      uses: actions/upload-artifact@v3
      with:
        name: compiled-pdf
        path: main.pdf
```

### PDFの基本的な検証

PDFの内容を簡易的に検証する方法：

```bash
# PDFのページ数を確認（pdfinfoが必要）
pdfinfo main.pdf | grep "Pages:"

# PDFからテキストを抽出して特定の文字列が含まれているか確認（pdftotextが必要）
pdftotext main.pdf - | grep "画像処理実験"

# PDFのメタデータを確認
pdfinfo main.pdf
```

### より高度な検証スクリプト

**test_compile_advanced.sh**:

```bash
#!/bin/bash

# 基本的なコンパイルテストを実行
./test_compile.sh
if [ $? -ne 0 ]; then
    echo "基本的なコンパイルテストに失敗しました"
    exit 1
fi

# PDFツールがインストールされているか確認
if command -v pdfinfo &> /dev/null; then
    echo "[INFO] PDFの詳細をチェック中..."

    # ページ数チェック
    PAGE_COUNT=$(pdfinfo main.pdf | grep "Pages:" | awk '{print $2}')
    echo "[INFO] ページ数: $PAGE_COUNT"

    if [ "$PAGE_COUNT" -lt 1 ]; then
        echo "[FAIL] PDFにページがありません"
        exit 1
    fi
    echo "[PASS] PDFページ数チェック成功"
fi

if command -v pdftotext &> /dev/null; then
    echo "[INFO] PDFテキスト内容をチェック中..."

    # 必須キーワードのチェック
    KEYWORDS=("画像処理実験" "中嶋 空偉" "NAKAJIMA")

    for keyword in "${KEYWORDS[@]}"; do
        if pdftotext main.pdf - | grep -q "$keyword"; then
            echo "[PASS] キーワード '$keyword' が見つかりました"
        else
            echo "[WARN] キーワード '$keyword' が見つかりませんでした"
        fi
    done
fi

echo "[INFO] すべての検証が完了しました"
```

### Makefileによる自動化

**Makefile**:

```makefile
.PHONY: all test clean

# デフォルトターゲット
all: main.pdf

# LaTeXコンパイル
main.pdf: main.tex
	platex main.tex
	platex main.tex
	dvipdfmx main.dvi

# テスト実行
test:
	@echo "Running compilation test..."
	@bash test_compile.sh

# クリーンアップ
clean:
	rm -f *.aux *.log *.dvi *.fls *.fdb_latexmk *.synctex.gz *.out *.toc

# 完全クリーンアップ（PDFも削除）
distclean: clean
	rm -f *.pdf

# 監視モード（ファイル変更時に自動コンパイル）
watch:
	@echo "Watching for changes..."
	@while true; do \
		inotifywait -e modify main.tex 2>/dev/null && make all; \
	done
```

使用方法：
```bash
# コンパイル
make

# テスト実行
make test

# クリーンアップ
make clean
```

## Document Structure and Template

All reports use this standard structure:

- **Document class**: `\documentclass[autodetect-engine,dvi=dvipdfmx,ja=standard,a4j,11pt]{bxjsarticle}`
- **Required packages**: `geometry`, `graphicx`, `fancyvrb`, `spverbatim`, `amsmath`
- **Page geometry**: A4 (210mm × 297mm) with custom margins
- **Title format**: `画像処理実験 第N回`
- **Date format**: `\number\year 年\number\month 月\number\day 日`

### Code listings format

Use the `Verbatim` environment with line numbers for Python code:

```latex
\begin{Verbatim}[numbers=left, xleftmargin=10mm, numbersep=6pt,
                 fontsize=\small, baselinestretch=0.8]
def example_function():
    pass
\end{Verbatim}
```

### Image insertion

```latex
\begin{figure}[h]
    \centering
    \includegraphics[scale=.5]{images/1/pic1.jpg}
    \caption{説明文}
    \label{fig:label-name}
\end{figure}
```

**重要**: LaTeX (platex + dvipdfmx) では **SVGファイルは直接読み込めません**．SVG画像を使用する場合は，必ずJPGまたはPNG形式に変換してから使用すること．

SVGからJPGへの変換方法:
```bash
# rsvg-convertとmagickを使用
rsvg-convert -f png input.svg | magick png:- output.jpg
```

## Core Image Processing Concepts

The reports document Python-based image processing using NumPy. Key transformation functions:

### Affine Transformations (afn, afn2, afn3)

- **afn**: Basic transformation using relative coordinates (dy, dx with center offset)
- **afn2**: Absolute coordinate version (y, x for entire image)
- **afn3**: Production-ready with boundary checking to prevent array access errors

Boundary checking pattern:
```python
m = (0<=u) & (u<src.shape[1]) & (0<=v) & (v<src.shape[0])
im[y[m], x[m]] = src[v[m].astype('i'), u[m].astype('i')]
```

### Projective Transformation (proj)

Implements homogeneous coordinate transformation for panorama stitching:

```python
# Calculate homogeneous coordinates
u = a[0,0]*x + a[0,1]*y + a[0,2]
v = a[1,0]*x + a[1,1]*y + a[1,2]
w = a[2,0]*x + a[2,1]*y + a[2,2]

# Convert to 2D coordinates BEFORE boundary check
u, v = u/w, v/w

# Apply boundary mask
m = (0<=u) & (u<src.shape[1]) & (0<=v) & (v<src.shape[0])
```

**Critical**: Divide by `w` before boundary checking to avoid out-of-range errors.

### Homography Calculation (makeAb)

Constructs the linear system for solving homography from 4 point correspondences:

```python
def makeAb(w):
    A = np.zeros((8,8), 'd')
    b = np.zeros(8, 'd')
    i = np.array([0,1,2,3])

    # Use vectorized indexing to avoid loops
    A[i*2+0, 0] = w[i, 0]
    A[i*2+0, 1] = w[i, 1]
    # ... (pattern continues)

    b[i*2] = w[i, 2]
    b[i*2+1] = w[i, 3]
    return A, b
```

**Key principle**: Replace Python loops with NumPy vectorized operations using integer array indexing.

### Transformation Matrix Conventions

- **m0d**: Global display position matrix (controls where output appears)
- **m10**: Relative transformation from image1 to image0
- **Composition**: `m1d = m0d @ m10` (using @ for matrix multiplication)

When m0d changes, the overall position shifts but the relative relationship between images is preserved.

## Development Philosophy

From `past/plan.md`, the final report emphasizes **iterative refinement**:

1. Create initial program
2. Identify problems
3. Implement improvements
4. Document insights and thought process
5. Repeat

The grading focuses on **what is written in the final report**. Source code is used only for verification. Therefore, reports should emphasize:

- Why certain approaches were chosen
- What problems were encountered
- How solutions were developed
- What was learned from failures and successes

## Working with This Repository

### When editing .tex files

- Preserve UTF-8 encoding for Japanese text
- Maintain consistent section structure: `\section{}`, `\subsection{}`, `\subsubsection{}`
- Use proper figure references with `\label{}` and `\ref{}`
- Include `\clearpage` before major sections if needed

### Image organization

- Store images in `images/N/` where N is the report number
- Use common test images (0.jpg - 6.jpg) from `images/common/`
- Reference images with relative paths: `images/1/pic1.jpg`

### Git workflow

- Current branch: `main`
- Write meaningful commit messages describing which section was modified
- The repository currently has untracked LaTeX build artifacts (.aux, .log, .dvi, .pdf, etc.)

## Git管理の設定

### .gitignoreの作成

LaTeXのビルド成果物や一時ファイルをバージョン管理から除外するため，`.gitignore`ファイルを作成します．

**推奨する.gitignoreの内容**：

```gitignore
# LaTeX intermediate files
*.aux
*.log
*.dvi
*.fls
*.fdb_latexmk
*.synctex.gz
*.out
*.toc
*.lof
*.lot
*.bbl
*.blg
*.bcf
*.run.xml

# LaTeX output files (PDFは必要に応じてコメントアウト)
*.pdf

# macOS files
.DS_Store
.AppleDouble
.LSOverride

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Editor backup files
*~
*.swp
*.swo
\#*\#
.#*

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
```

### .gitignoreの作成方法

```bash
# リポジトリのルートディレクトリで実行
cat > .gitignore << 'EOF'
# LaTeX intermediate files
*.aux
*.log
*.dvi
*.fls
*.fdb_latexmk
*.synctex.gz
*.out
*.toc
*.lof
*.lot
*.bbl
*.blg
*.bcf
*.run.xml

# LaTeX output files
*.pdf

# macOS files
.DS_Store

# Editor backup files
*~
*.swp
*.swo
EOF

# .gitignoreをステージングエリアに追加
git add .gitignore

# コミット
git commit -m "Add .gitignore for LaTeX and macOS files"
```

### 既存の追跡済みファイルを削除する

既にgitで追跡されているビルド成果物を削除する場合：

```bash
# キャッシュから削除（ファイル自体は削除されない）
git rm --cached *.aux *.log *.dvi *.pdf *.fls *.fdb_latexmk *.synctex.gz .DS_Store

# .gitignoreをコミット
git add .gitignore
git commit -m "Remove LaTeX build artifacts from git tracking"
```

### 推奨するコミットメッセージの形式

```
[種類] 簡潔な説明

詳細な説明（必要に応じて）

例：
- [追加] 第3回レポートのmakeAb関数実装を追加
- [修正] 第2回の画像パスを修正
- [改善] 図のキャプションを説明的に変更
- [削除] 不要なTODOコメントを削除
- [リファクタ] 関数名をverbで囲むように修正
```

### 基本的なgitコマンド

```bash
# 現在の状態を確認
git status

# 変更をステージングエリアに追加
git add main.tex
git add images/3/

# すべての変更を追加（慎重に使用）
git add .

# コミット
git commit -m "[追加] 第3回レポートを追加"

# コミット履歴を確認
git log --oneline

# 差分を確認
git diff main.tex

# リモートリポジトリにプッシュ（設定されている場合）
git push origin main
```

### ブランチ運用（推奨）

大きな変更を行う際は，ブランチを作成して作業することを推奨します：

```bash
# 新しいブランチを作成して切り替え
git checkout -b feature/improve-labels

# 作業を行う
# （main.texを編集）

# 変更をコミット
git add main.tex
git commit -m "[改善] 図のラベル命名規則を統一"

# mainブランチに戻る
git checkout main

# ブランチをマージ
git merge feature/improve-labels

# 不要になったブランチを削除
git branch -d feature/improve-labels
```

## ローカルファイルベースのIssue管理

GitHub APIや`gh`コマンドが利用できない環境でも，ローカルファイルベースでIssueを管理できます．

### Issue管理の仕組み

- **保存場所**：`.github/issues/`ディレクトリ
- **ファイル形式**：Markdown（YAML frontmatterを使用）
- **命名規則**：`{番号}-{状態}.md`（例：`1-open.md`，`2-closed.md`）

### Issue管理コマンド

#### 基本コマンド

```bash
# Issue一覧を表示
./issue list

# オープンなIssueのみ表示
./issue list --open

# クローズ済みIssueのみ表示
./issue list --closed

# Issue詳細を表示
./issue show 1

# 新しいIssueを作成（対話式）
./issue create

# Issueをクローズ
./issue close 1

# Issueを再オープン
./issue reopen 1
```

#### Makefileショートカット

```bash
# Issue一覧を表示
make issues

# 新しいIssueを作成
make issue-create

# Issue詳細を表示（N=番号）
make issue-show N=1

# Issueをクローズ（N=番号）
make issue-close N=1
```

### Issueファイルの形式

各Issueは以下のフォーマットで保存されます：

```markdown
---
number: 1
title: "関数名をverbで囲む"
state: open
labels: ["改善", "優先度:高"]
created: 2025-11-09
updated: 2025-11-09
---

## 目的
本文中の関数名を\verb||で囲む

## 対象箇所
- afn, afn2, afn3
- proj
- makeAb

## タスク
- [ ] 第1回セクションを修正
- [ ] 第2回セクションを修正
- [ ] 第3回セクションを修正
```

### Issue作成の実践例

#### 例1：改善タスクの作成

```bash
$ ./issue create
タイトル: 関数名をverbで囲む
ラベル（カンマ区切り）: 改善,優先度:高
本文（空行を2回入力で終了）:
## 目的
本文中の関数名を\verb||で囲む

## 対象箇所
- afn, afn2, afn3関数
- proj関数
- makeAb関数

[SUCCESS] Issue #1 を作成しました: .github/issues/1-open.md
```

#### 例2：Issueのクローズ

作業完了後，Issueをクローズします：

```bash
# 方法1：コマンドで直接クローズ
./issue close 1

# 方法2：Makefileから
make issue-close N=1

# 方法3：Gitコミットメッセージで参照（手動でクローズが必要）
git commit -m "[改善] 関数名をverbで囲む

See: Issue #1"

# コミット後に手動でクローズ
./issue close 1
```

### Issue一覧の表示例

```bash
$ ./issue list
=========================================
Issue一覧
=========================================
#1 関数名をverbで囲む [改善, 優先度:高]
#2 図のキャプションを改善 [改善, 優先度:中]
#3 コンパイルテストの追加 [テスト, 優先度:高]
=========================================
合計: 3 件
```

### Gitでの管理

Issueファイルもバージョン管理の対象です：

```bash
# 新しいIssueを作成後
git add .github/issues/1-open.md
git commit -m "[追加] Issue #1: 関数名をverbで囲む"

# Issueをクローズ後
git add .github/issues/1-closed.md
git commit -m "[クローズ] Issue #1: 関数名をverbで囲む作業完了"
```

### GitHub Issueとの連携

GitHub CLIが利用可能になった場合，ローカルIssueをGitHub Issueに移行できます：

```bash
# ローカルIssueを読んでGitHub Issueを作成
for file in .github/issues/*-open.md; do
    title=$(grep "^title:" "$file" | sed 's/title: "\(.*\)"/\1/')
    body=$(sed '1,/^---$/d' "$file" | sed '1,/^---$/d')
    gh issue create --title "$title" --body "$body"
done
```

## GitHub Issueによるタスク管理

### Issueを使ったタスク管理のメリット

LaTeXレポート作成において，GitHub Issueは以下の理由で有効です：

1. **バージョン管理との統合**：コミットメッセージで `close #1` と書けば自動的にissueがクローズされる
2. **履歴の可視化**：各回のレポート作成や改善作業の履歴が残る
3. **Markdown対応**：数式やコードブロックも記述可能
4. **GitHub CLIで効率的**：コマンドラインから直接操作可能

### Issue作成の推奨方法

#### パターン1：レポート作成タスク

```bash
# 第N回のレポート作成issue
gh issue create \
  --title "第4回レポート作成" \
  --body "## 目的
第4回の画像処理実験レポートを作成する

## タスク
- [ ] 特徴点検出の実装
- [ ] SIFT/ORB特徴量の比較
- [ ] 実行結果の画像取得
- [ ] 考察の記述
- [ ] 感想の記述

## 締め切り
2025-XX-XX
" \
  --label "レポート作成"
```

#### パターン2：改善タスク

```bash
# 改善タスクのissue作成
gh issue create \
  --title "関数名をverbで囲む" \
  --body "## 目的
CLAUDE.mdのrulesに従い，本文中の関数名を\verb||で囲む

## 対象
- afn, afn2, afn3
- proj
- makeAb
- calcHomography

## 参考
CLAUDE.md の「追加改善要項」セクション参照
" \
  --label "改善"
```

#### パターン3：バグ修正

```bash
gh issue create \
  --title "図の参照が未解決" \
  --body "## 問題
コンパイル時に以下の警告が出る：
\`\`\`
LaTeX Warning: Reference 'fig:xxx' on page X undefined.
\`\`\`

## 原因
\label{fig:xxx} が存在しない

## 対応
該当する図にラベルを追加する
" \
  --label "バグ"
```

### ラベルの推奨設定

```bash
# ラベルを作成
gh label create "レポート作成" --color "0e8a16" --description "新しいレポートの作成"
gh label create "改善" --color "fbca04" --description "既存レポートの品質改善"
gh label create "バグ" --color "d73a4a" --description "エラーや問題の修正"
gh label create "第1回" --color "c5def5" --description "第1回レポート関連"
gh label create "第2回" --color "c5def5" --description "第2回レポート関連"
gh label create "第3回" --color "c5def5" --description "第3回レポート関連"
gh label create "優先度:高" --color "b60205" --description "優先的に対応が必要"
gh label create "優先度:中" --color "fbca04" --description "通常の優先度"
gh label create "優先度:低" --color "0e8a16" --description "時間があれば対応"
```

### 基本的なIssue操作コマンド

```bash
# Issue一覧を表示
gh issue list

# 特定のラベルでフィルタ
gh issue list --label "レポート作成"

# Issueの詳細を表示
gh issue view 1

# Issueをクローズ
gh issue close 1

# Issueを再オープン
gh issue reopen 1

# Issueにコメント追加
gh issue comment 1 --body "実装完了しました"

# 自分にアサイン
gh issue edit 1 --add-assignee @me
```

### コミットメッセージでIssueを操作

```bash
# Issueを参照
git commit -m "[追加] 第3回レポートを追加 (#3)"

# Issueを自動クローズ
git commit -m "[修正] 図の参照エラーを修正

close #5"

# 複数のIssueを同時にクローズ
git commit -m "[改善] 関数名をverbで囲む

fix #10, fix #11, close #12"
```

### Issue管理の実践例

#### 例1：追加改善要項をIssueで管理

CLAUDE.mdの「追加改善要項」に記載された5つの改善項目をissueとして作成：

```bash
# 優先度:高
gh issue create --title "関数名・変数名をverbで囲む" \
  --body "$(cat <<'EOF'
## 目的
CLAUDE.mdのrulesに従い，本文中の関数名や変数名を\verb||で囲む

## 対象箇所
- afn, afn2, afn3
- proj
- makeAb
- calcHomography
- m0d, m10, m1d
- u, v, w, x, y

## 参考
CLAUDE.md「追加改善要項」セクション1
EOF
)" \
  --label "改善" --label "優先度:高"

# 優先度:中
gh issue create --title "図のラベル命名規則を統一" \
  --body "$(cat <<'EOF'
## 目的
図のラベルを統一形式に変更する

## 推奨形式
fig:[section]-[type]-[number]

例：
- fig:1-input-1（第1回の入力画像1）
- fig:2-panorama-100（第2回のパノラマ画像）
- fig:3-result-near（第3回の近接特徴点での結果）

## 参考
CLAUDE.md「追加改善要項」セクション2
EOF
)" \
  --label "改善" --label "優先度:中"
```

#### 例2：レポート作成の進捗管理

```bash
# 第4回レポートのissueを作成
gh issue create --title "第4回レポート：特徴点マッチング" \
  --body "$(cat <<'EOF'
## 概要
特徴点検出とマッチングの実装

## タスク
- [ ] SIFT特徴量の実装
- [ ] ORB特徴量の実装
- [ ] マッチング結果の可視化
- [ ] 精度比較実験
- [ ] 実験結果の画像取得（images/4/に保存）
- [ ] レポート本文の執筆
- [ ] 考察の記述
- [ ] 感想の記述
- [ ] コンパイルテスト実行

## 締め切り
2025-XX-XX

## 参考
- past/rep4.tex
- past/plan.md
EOF
)" \
  --label "レポート作成" --label "第4回"
```

### Issueテンプレートの作成

`.github/ISSUE_TEMPLATE/`ディレクトリにテンプレートを作成すると，issue作成時に自動的にフォーマットが適用されます：

**.github/ISSUE_TEMPLATE/report.md**:
```markdown
---
name: レポート作成
about: 新しい回のレポートを作成する
title: '第X回レポート：[タイトル]'
labels: 'レポート作成'
assignees: ''
---

## 概要
<!-- レポートの目的を簡潔に記述 -->

## タスク
- [ ] 実装
- [ ] 実行結果の画像取得
- [ ] レポート本文の執筆
- [ ] 考察の記述
- [ ] 感想の記述
- [ ] コンパイルテスト実行

## 締め切り
<!-- 締め切り日を記入 -->

## 参考
<!-- 参考資料へのリンク -->
```

**.github/ISSUE_TEMPLATE/improvement.md**:
```markdown
---
name: 改善
about: 既存レポートの品質改善
title: '[改善] '
labels: '改善'
assignees: ''
---

## 目的
<!-- 何を改善するのか -->

## 対象箇所
<!-- 改善対象のファイルや行番号 -->

## 参考
<!-- CLAUDE.mdの該当セクションなど -->
```

## LaTeX Writing Guidelines (main.texの書き方)

### 本文の書き方

1. **セクション構成**
   - \verb|\section{}|：大見出し（例：「概要」「第N回」「感想」）
   - \verb|\subsection{}|：中見出し（例：「対応の確認」「makeAb関数の実装」）
   - \verb|\subsubsection{}|：小見出し（例：「処理1」「実行結果」）
   - \verb|\paragraph{}|：段落見出し（例：「変更内容」「結論」）

2. **文章スタイル**
   - 句読点は「，」「．」を使用する
   - 「である調」で統一する
   - 図や表への参照は「図\verb|\ref{fig:label-name}|に示すように」のように記述する
   - 関数名や変数名は\verb|\verb|Hoge||で囲う（例：\verb|\verb|afn||，\verb|\verb|makeAb||）

3. **箇条書き**
   ```latex
   \begin{itemize}
       \item 項目1
       \item 項目2
       \item 項目3
   \end{itemize}
   ```

4. **段落区切り**
   - セクション間で大きく内容が変わる場合は\verb|\clearpage|を使用して改ページする
   - 通常の段落区切りは空行を入れる

### 画像の貼り方

#### 単独の画像を貼る場合

```latex
\begin{figure}[h]
    \centering
    \includegraphics[scale=.5]{images/2/pic1.jpg}
    \caption{画像の説明文}
    \label{fig:unique-label}
\end{figure}
```

- \verb|[h]|：ここに配置（here）
- \verb|scale=.5|：縮尺50%（0.1〜1.0で調整）
- \verb|scale=.1|：小さめの画像（パノラマ画像など大きい画像向け）
- \verb|scale=.3|：中くらいの画像
- \verb|scale=.5|：標準的なサイズ
- \verb|\label{fig:xxx}|：必ず\verb|fig:|から始める
- **重要**：\verb|\caption{}|の中では\verb|\verb|コマンドは使用できない．関数名などは通常のテキストで記述すること

#### 横に複数の画像を並べる場合（2枚）

```latex
\begin{figure}[h]
    \centering
    \begin{minipage}{0.32\linewidth}
        \centering
        \includegraphics[scale=.3]{images/1/result.jpg}
        \caption{画像1.1}
        \label{fig:result1-1}
    \end{minipage}
    \hfill
    \begin{minipage}{0.32\linewidth}
        \centering
        \includegraphics[scale=.3]{images/1/result2.jpg}
        \caption{画像1.2}
        \label{fig:result1-2}
    \end{minipage}
\end{figure}
```

#### 横に3枚の画像を並べる場合

```latex
\begin{figure}[h]
    \centering
    \begin{minipage}{0.32\linewidth}
        \centering
        \includegraphics[scale=.5]{images/1/pic1.jpg}
        \caption{画像1.1}
        \label{fig:image1-1}
    \end{minipage}
    \hfill
    \begin{minipage}{0.32\linewidth}
        \centering
        \includegraphics[scale=.5]{images/1/pic2.jpg}
        \caption{画像1.2}
        \label{fig:image1-2}
    \end{minipage}
    \hfill
    \begin{minipage}{0.32\linewidth}
        \centering
        \includegraphics[scale=.5]{images/1/pic3.jpg}
        \caption{画像1.3}
        \label{fig:image1-3}
    \end{minipage}
\end{figure}
```

- \verb|0.32\linewidth|：幅を行の32%に設定（3枚並べる場合）
- \verb|\hfill|：画像間の空白を自動調整

### Pythonコードの書き方

#### 標準的なコード挿入（行番号付き）

```latex
\begin{Verbatim}[numbers=left, xleftmargin=10mm, numbersep=6pt,
                    fontsize=\small, baselinestretch=0.8]
def makeAb(w):
    A = np.zeros((8,8), 'd')
    b = np.zeros(8, 'd')
    i = np.array([0,1,2,3])

    A[i*2+0, 0] = w[i, 0]
    A[i*2+0, 1] = w[i, 1]

    return A, b
\end{Verbatim}
```

**オプション説明**：
- \verb|numbers=left|：行番号を左側に表示
- \verb|xleftmargin=10mm|：左マージン10mm
- \verb|numbersep=6pt|：行番号とコードの間隔6pt
- \verb|fontsize=\small|：フォントサイズを小さく
- \verb|baselinestretch=0.8|：行間を0.8倍に圧縮

#### 行番号なしの短いコード片

```latex
\begin{verbatim}
m = (0<=u)&(u<src.shape[1])&(0<=v)&(v<src.shape[0])
\end{verbatim}
```

- 小文字の\verb|\begin{verbatim}|は行番号なし
- 1〜2行程度の短いコード片に使用

### 数式の書き方

#### インライン数式（文中）

```latex
変換後の座標$(u,v)$が元画像の有効範囲内にある場合
最終的な変換が$m0d \times m10$で計算される
```

#### ディスプレイ数式（独立した行）

```latex
\[
A = \begin{pmatrix}
x_0 & y_0 & 1 & 0 & 0 & 0 & -u_0x_0 & -u_0y_0 \\
0 & 0 & 0 & x_0 & y_0 & 1 & -v_0x_0 & -v_0y_0 \\
x_1 & y_1 & 1 & 0 & 0 & 0 & -u_1x_1 & -u_1y_1 \\
0 & 0 & 0 & x_1 & y_1 & 1 & -v_1x_1 & -v_1y_1
\end{pmatrix}
\]
```

- \verb|\[| ... \verb|\]|：番号なしの数式
- \verb|\begin{pmatrix}|：丸括弧の行列
- \verb|\\|：行の区切り
- \verb|&|：列の区切り

### 図表の参照方法

```latex
% ラベルの定義
\label{fig:panorama}
\label{fig:image100}
\label{fig:result1-1}

% 本文での参照
図\ref{fig:panorama}に示す通り，
図\ref{fig:image100}と図\ref{fig:image200}を比較すると，
```

**命名規則**：
- 図：\verb|fig:xxx|
- 表：\verb|tab:xxx|
- セクション：\verb|sec:xxx|
- 数式：\verb|eq:xxx|

### レポート構成の典型パターン

```latex
\section{概要}
実験の目的と概要を2〜3行で説明

\section{第N回 タイトル}

\subsection{課題1のタイトル}
\subsubsection{実装内容}
実装の説明

\subsubsection{実行結果}
結果の説明と図の挿入

\paragraph{考察}
結果に対する考察

\subsection{課題2のタイトル}
...

\clearpage

\section{感想}
実験全体を通して学んだこと，難しかった点など
```

### 特殊な記法

#### テキストを強調する

```latex
\textbf{太字テキスト}
\textit{斜体テキスト}
```

#### コード中の特定部分にコメント

```latex
y,x=np.mgrid[0:dh,0:dw]                     # (i)
m = (0<=u)&(u<src.shape[1])&(0<=v)&(v<src.shape[0]) # (iv)
```

- コメント記号\verb|#|の後に\verb|(i)|，\verb|(iv)|などの番号を付けて，本文で参照できる

#### verbatimとVerbatimの使い分け

- \verb|\begin{verbatim}|（小文字）：行番号なし，短いコード片
- \verb|\begin{Verbatim}|（大文字）：行番号あり，長いプログラム全体

### 画像ファイルの配置ルール

1. **ディレクトリ構造**
   ```
   images/
   ├── 1/          # 第1回のレポート用画像
   ├── 2/          # 第2回のレポート用画像
   └── common/     # 共通テスト画像（0.jpg〜6.jpg）
   ```

2. **ファイル名の付け方**
   - 処理結果：\verb|result.jpg|，\verb|result2.jpg|
   - 特定の処理名：\verb|pic1.jpg|，\verb|pic2.jpg|
   - パノラマ画像：\verb|100_100.jpg|，\verb|200_200.jpg|（パラメータ値を含む）
   - 元画像：\verb|5500.jpg|（処理パラメータを示す）

3. **画像パスの記述**
   ```latex
   \includegraphics[scale=.5]{images/1/pic1.jpg}  # 絶対パス
   ```
   - 必ず\verb|images/N/|から始める相対パスを使用する

## 追加改善要項（Future Improvements）

以下は，main.texの品質をさらに向上させるための推奨事項です．大規模な変更になるため，必要に応じて実施してください．

### 1. 本文中の関数名・変数名を\verb||で囲む

**目的**：CLAUDE.mdのrulesに従い，関数名や変数名を\verb|\verb|Hoge||で囲むことで，可読性を向上させる．

**対象箇所**：
- \verb|afn|，\verb|afn2|，\verb|afn3|：アフィン変換関数
- \verb|proj|：射影変換関数
- \verb|makeAb|：行列A，bを生成する関数
- \verb|calcHomography|：ホモグラフィ行列を計算する関数
- \verb|m0d|，\verb|m10|，\verb|m1d|：変換行列
- その他の変数名：\verb|u|，\verb|v|，\verb|w|，\verb|x|，\verb|y|など

**例**：
```latex
修正前：afn関数は相対座標を使用する．
修正後：\verb|afn|関数は相対座標を使用する．
```

**注意**：
- \verb|\caption{}|の中では\verb|\verb|コマンドは使用できないため，キャプション内では通常のテキストのまま記述する
- 数式環境（\verb|$...$|や\verb|\[...\]|）内でも\verb|\verb|は使用できない

### 2. 図のキャプションの改善

**目的**：図のキャプションをより説明的にし，何を示している図なのか一目でわかるようにする．

**改善例**：
```latex
現状：\caption{画像1.1}
推奨：\caption{元画像（奇数行を黒に変換）}

現状：\caption{処理結果1}
推奨：\caption{処理7の実行結果（回転・拡大）}

現状：\caption{afn3の結果}
推奨：\caption{afn3関数による境界チェック付き変換結果}

現状：\caption{近い位置に取った特徴点}
推奨：\caption{近接した4点の特徴点配置（品質低下の例）}
```

### 3. セクション間に一貫性を持たせる

**目的**：各回のレポート構成を統一し，読みやすくする．

**推奨構成**：
```latex
\section{第N回 タイトル}

\subsection{課題1：...}
\subsubsection{実装内容}
...
\subsubsection{実行結果}
...
\paragraph{考察}
...

\subsection{課題2：...}
...

\subsection{感想}
実験全体を通して学んだこと，難しかった点など
```

**注意**：
- 各回に必ず「感想」サブセクションを含める
- 「実装内容」「実行結果」「考察」の順序を統一する

### 4. コードコメントの日本語化

**目的**：Verbatim環境内のコードコメントを日本語にし，理解しやすくする．

**例**：
```latex
\begin{Verbatim}[...]
y,x=np.mgrid[0:dh,0:dw]                     # 出力画像の座標グリッド生成
m = (0<=u)&(u<src.shape[1])&(0<=v)&(v<src.shape[0]) # 境界チェック
im[y[m],x[m]]= src[v[m].astype('i'),u[m].astype('i')] # マスク適用して代入
\end{Verbatim}
```

### 実施優先度

1. **高**：本文中の関数名を\verb||で囲む（CLAUDE.mdのrulesに直接関連）
2. **低**：図のキャプションの改善（可読性向上）
3. **低**：セクション間の一貫性（既にほぼ達成済み）
4. **低**：コードコメントの日本語化（補足的改善）

## Issue対応の手順

このセクションでは，GitHub Issueに記載されたタスクを実行する際の具体的な手順を説明します．

### main.texの構造（重要）

作業を開始する前に，main.texの構造を理解してください：

```
main.tex の構造：
├── 1-29行目:   プリアンブル（documentclass, パッケージ, タイトル情報）
├── 30-128行目:  第1回セクション（numpyでの配列操作と画像処理の基本）
├── 130-338行目: 第2回セクション（画像の幾何学的処理について学ぶ）
├── 340-495行目: 第3回セクション（変換行列を求める）
└── 495行目:    \end{document}
```

### Issue対応の基本フロー

すべてのissue対応は以下の流れで行います：

1. **Grepで対象箇所を特定**
2. **main.texを編集**
3. **コンパイルテストを実行** (`make test`)
4. **変更をコミット**
5. **Issueをクローズ**

### 関数名・変数名を`\verb||`で囲む手順

#### 対象Issue
- Issue #1: afn, afn2, afn3関数
- Issue #2: proj関数
- Issue #3: makeAb関数
- Issue #4: m0d, m10, m1d変数

#### 手順

**Step 1: 対象箇所を特定**

```bash
# 例：afn関数を検索
grep -n "afn" main.tex | grep -v "Verbatim" | grep -v "verb"

# 第2回セクションのみに絞る場合
sed -n '130,338p' main.tex | grep -n "afn"
```

**Step 2: 編集ルール**

✅ **変更する箇所**：
- 本文中の関数名・変数名（例：「afn関数は」→「\verb|afn|関数は」）
- 説明文中の関数名・変数名

❌ **変更しない箇所**：
- `\begin{Verbatim}` ... `\end{Verbatim}` 内のコード
- `\begin{verbatim}` ... `\end{verbatim}` 内のコード
- `\caption{...}` 内（LaTeXの制約により`\verb`使用不可）
- 数式環境 `$...$` や `\[...\]` 内（LaTeXの制約により`\verb`使用不可）

**Step 3: 編集例**

修正前：
```latex
afn関数は相対座標を使用する．afn2関数は絶対座標を使用する．
```

修正後：
```latex
\verb|afn|関数は相対座標を使用する．\verb|afn2|関数は絶対座標を使用する．
```

**Step 4: コンパイルテスト**

```bash
make test
```

以下を確認：
- ✅ コンパイル成功
- ✅ 警告なし（または警告が増えていない）
- ✅ 未解決の参照なし

**Step 5: コミット & Issue クローズ**

```bash
git add main.tex
git commit -m "[改善] afn系関数名をverbで囲む

close #1"

git push origin main
```

### コミット作業の手順

#### 対象Issue
- Issue #5: .gitignore, Makefile, test_compile.shをコミット
- Issue #6: CLAUDE.mdの更新をコミット
- Issue #7: main.texの修正をコミット

#### 手順

**Step 1: 変更ファイルを確認**

```bash
git status
```

**Step 2: ステージング**

```bash
# Issue #5の場合
git add .gitignore Makefile test_compile.sh .github/ISSUE_TEMPLATE/

# Issue #6の場合
git add CLAUDE.md

# Issue #7の場合
git add main.tex
```

**Step 3: コミット**

Issue本文に記載されたコミットメッセージを使用します．

**Step 4: プッシュ**

```bash
git push origin main
```

**Step 5: Issueをクローズ**

```bash
# GitHub CLIを使用する場合
unset GITHUB_TOKEN && gh issue close 5

# または，コミットメッセージに "close #5" を含めれば自動クローズ
```

### よくある注意点

#### 1. `\verb`が使えない場所

以下の場所では`\verb`コマンドは使用できません：

❌ **caption内**：
```latex
\caption{\verb|afn|の結果}  # エラー
\caption{afnの結果}         # OK
```

❌ **数式環境内**：
```latex
$\verb|u|$                  # エラー
$u$                         # OK
```

❌ **他のコマンドの引数内**：
```latex
\section{\verb|afn|関数}    # エラー
\section{afn関数}           # OK
```

#### 2. ラベル変更時は`\ref{}`も必ず変更

`\label{}`を変更したら，必ず対応するすべての`\ref{}`も変更してください．
変更漏れがあると「未解決の参照」エラーになります．

```bash
# 検証コマンド
make test
# "Reference ... undefined" が出力されたら変更漏れ
```

#### 3. コンパイルテストは必須

すべての変更後，必ず`make test`を実行してください．

```bash
make test
```

確認項目：
- ✅ コンパイル成功
- ✅ PDFが生成される
- ✅ 未解決の参照エラーなし
- ⚠️  警告は5個程度（float specifier）は許容範囲

#### 4. セクションごとに作業を分割

大きな変更は1つのissueで完結させず，セクション（第1回，第2回，第3回）ごとに分割してください．
これにより：
- 作業が管理しやすくなる
- エラーが発生した場合の原因特定が容易
- コミット履歴が明確になる

### トラブルシューティング

#### コンパイルエラーが発生した場合

```bash
# エラーログを確認
cat main.log | grep "Error"

# よくあるエラー：
# 1. \verb がcaption内に使われている
# 2. \verb が数式環境内に使われている
# 3. 括弧の閉じ忘れ
```

#### 未解決の参照エラーが出る場合

```bash
# どのラベルが未解決か確認
cat main.log | grep "undefined"

# 該当する\ref{}を検索
grep "\\ref{fig:xxx}" main.tex
```

#### Gitコンフリクトが発生した場合

```bash
# 最新の変更を取得
git pull origin main

# コンフリクトを解決後
git add main.tex
git commit -m "Merge conflict resolved"
git push origin main
```

