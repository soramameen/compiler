# 最終レポート案

## 1. 実験の目的
本実験の目的は、C言語のサブセットを対象としたコンパイラを設計・実装し、ソースコードからMIPSアーキテクチャの計算機（maps）で実行可能なアセンブリコードを生成する過程を理解することである。

## 2. 最終的に作成した言語の定義 (BNF)
`program.y` に基づく文法定義を以下に示す。

```yacc
program
    : declarations statements
;

declarations
    : decl_statement declarations
    | decl_statement
;

decl_statement
    : DEFINE IDENT SEMIC

statements
    : statement statements
    | statement
;

statement
    : assignment_stmt
    | loop_stmt
    | cond_stmt
    | expression SEMIC
;

assignment_stmt
    : IDENT ASSIGN expression SEMIC

expression
    : expression PLUS term
    | expression MINUS term
    | term

term
    : term MUL factor
    | term DIV factor
    | factor

factor
    : var
    | NUMBER
    | L_PAREN expression R_PAREN

var
    : IDENT

loop_stmt
    : WHILE L_PAREN condition R_PAREN L_BRACE statements R_BRACE

cond_stmt
    : IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE
    | IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE

condition
    : expression EQ expression
    | expression LT expression
```

## 3. コード生成までできている範囲
本コンパイラでは以下の機能を実装し、コード生成が可能である。
- 変数宣言 (`define`)：整数型変数の宣言。
- 代入文：変数への数値または式の計算結果の代入。
- 四則演算 (`+`, `-`, `*`, `/`)：整数間の演算。
- 比較演算 (`==`, `<`)：条件式での利用。
- 制御構造 (`if`, `if-else`, `while`)：条件分岐およびループ。
- ローカル変数のスタック割り当て：関数内での変数管理。

## 4. 定義した言語で受理されるプログラムの例
```c
define i;
define sum;
i = 1;
sum = 0;
while (i < 11) {
    sum = sum + i;
    i = i + 1;
}
```

## 5. コード生成の概要
### メモリの使い方
- **スタックフレームの構築:** 関数呼び出し時に `$sp` を動かし、`$ra`（戻りアドレス）と `$fp`（旧フレームポインタ）を保存する領域を確保する。
- **ローカル変数の配置:** `symbol_table` を用いて各変数に `$fp` からの負のオフセットを割り当てる。これにより、再帰呼び出し等にも対応可能なメモリ管理を行っている。

### レジスタの使い方
- `$v0`: 演算結果の格納、および関数の戻り値用として主に使用する。
- `$v1`: 二項演算において、スタックからポップした第2オペランドを一時的に保持するために使用する。
- `$sp`: スタックポインタ。データの退避・復帰に使用。
- `$fp`: フレームポインタ。ローカル変数へのアクセスの基準点として使用。

### 算術式のコード生成の方法
- AST（抽象構文木）を再帰的に巡回（ポストオーダー）して生成する。
- 二項演算（例：`a + b`）の場合：
    1. 右部分木（`b`）のコードを生成し、結果（`$v0`）をスタックに `push` する。
    2. 左部分木（`a`）のコードを生成し、結果を `$v0` に得る。
    3. スタックから `pop` して `$v1` に戻す。
    4. `$v0` と `$v1` の演算を行い、結果を `$v0` に格納する。
- このスタックマシン的なアプローチにより、複雑な入れ子構造の式も正しく計算できる。

## 6. 特に工夫した点
- **シンボルテーブルの事前走査:** `generate_code` の冒頭で `find_declarations` を呼び出し、AST全体から変数宣言を抽出することで、関数のプロローグで必要なスタックサイズを一括で計算・確保するようにした。
- **遅延分岐スロットの考慮:** MIPSアーキテクチャの特性である遅延分岐スロットによる意図しない動作を防ぐため、`j` や `beq` 命令の直後に `nop` を挿入する設計とした。

## 7. コンパイラのソースプログラムのある場所
`/Users/nakajimasoraera/dev/github.com/soramameen/compiler/c-compiler`

## 8. 最終課題を解くために書いたプログラム
最終課題として、1から30までの数値に対してFizzBuzzの判定を行い、それぞれの出現回数をカウントするプログラムを作成した。

```c
define fizz;
define buzz;
define fizzbuzz;
define others;
define i;
fizz = 0;
buzz = 0;
fizzbuzz = 0;
others = 0;
i = 1;
while(i < 31){
  if((i / 15)*15 == i){
    fizzbuzz = fizzbuzz + 1;
  }else{
    if((i/3)*3 == i){
      fizz = fizz + 1;
    }else{
      if((i/5)*5 == i){
        buzz = buzz +1;
      } else {
        others = others + 1;
      }
    }
  }
  i = i + 1;
}
others;
```

## 9. 実行結果とステップ数
上記プログラムを自作コンパイラでコンパイルし、`maps` シミュレータで実行した結果を以下に示す。

- **実行結果:** (ここに maps の出力を貼る。例：others の値が $v0 に入っていることの確認)
- **実行ステップ数:** (ここに maps で表示された Total Steps を記入)

## 10. 考察
### コード生成の効率性
現在の実装では、すべての演算結果を一度スタックに `push` し、次の演算で `pop` するスタックマシン的な手法を採用している。この手法はASTからの変換が直感的で実装が容易である一方、レジスタを直接活用する場合に比べて `sw` (store word) や `lw` (load word) 命令が多くなり、実行ステップ数が増大する要因となっている。

### 最適化の可能性
実行ステップ数を削減するためには、以下の最適化が考えられる。
1. **レジスタ割り当ての最適化:** 演算の中間結果を可能な限りレジスタ（`$t0`〜`$t9`など）に保持し、スタックへのアクセスを最小限にする。
2. **定数畳み込み:** `1 + 2` のような定数同士の演算をコンパイル時に計算しておくことで、実行時の命令数を減らす。
3. **遅延分岐スロットの活用:** 現在は一律に `nop` を挿入しているが、分岐に影響しない命令をスロットに移動させることで、`nop` を削減できる。

### まとめ
本実験を通じて、高水準言語の抽象的な構造（AST）が、どのように具体的な機械語命令へと変換され、メモリ（スタック）が管理されるのかを深く理解することができた。
