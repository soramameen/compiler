# C Compiler Project

このディレクトリは、独自Cコンパイラのソースコードと関連ファイルを格納しています。

## ディレクトリ構成

プロジェクトの構成は以下の通り整理されています。

```text
c-compiler/
├── Makefile            # ビルド管理用ファイル
├── src/                # コンパイラのソースコード (.c, .h, .l, .y)
│   ├── ast.c           # 抽象構文木 (AST) 関連
│   ├── codegen.c       # コード生成 (Assembly)
│   ├── symbol_table.c  # シンボルテーブル管理
│   ├── main.c          # エントリーポイント
│   ├── program.y       # 構文解析 (Bison)
│   └── c_program.l     # 字句解析 (Flex)
├── tests/              # テスト関連ファイル
│   ├── unit/           # 単体テスト用ドライバ (test_codegen.c など)
│   └── cases/          # テストケースとなるCソースコード (fizzbuzz.c など)
├── output/             # コンパイル結果のアセンブリファイル出力先 (.s)
├── docs/               # ドキュメント (レポート, GEMINIログなど)
└── hands-on/           # ハンズオン用課題ファイル
```

## ビルド方法

ルートディレクトリ (`c-compiler/`) で `make` コマンドを実行してください。

```bash
# コンパイラ本体のビルド
make

# クリーンアップ (生成ファイルや中間ファイルの削除)
make clean
```

ビルドが成功すると、カレントディレクトリに実行ファイル `program` が生成されます。

## 実行・テスト方法

生成されたコンパイラ `program` は、標準入力からソースコードを受け取り、標準出力にアセンブリコードを出力します。

### 基本的な使い方

```bash
./program < tests/cases/sample.c > output/sample.s
```

### 自動テスト・実行コマンド

Makefileには便利な実行コマンドが定義されています。

- **FizzBuzzの実行**:
  ```bash
  make run_fizzbuzz
  ```
  `tests/cases/fizzbuzz.c` をコンパイルし、`output/fizzbuzz.s` を生成して実行 (`maps -e`) します。

- **階乗計算 (kaizyo) の実行**:
  ```bash
  make run_kaizyo
  ```

- **エラトステネスの篩 (era) の実行**:
  ```bash
  make run_era
  ```

- **単体テストの実行**:
  ```bash
  # コード生成モジュールのテスト
  make test_codegen
  ./test_codegen
  ```

## 開発上の注意

- **ソースコードの変更**: `src/` ディレクトリ内のファイルを編集してください。
- **新しいテストケース**: `tests/cases/` に新しい `.c` ファイルを追加してください。
- **出力ファイル**: コンパイル結果のアセンブリファイルは `output/` ディレクトリに出力することをお勧めします。

## 依存関係
- GCC (or Clang)
- Flex
- Bison
- Maps (シミュレータ, `maps -e` でアセンブリ実行)
