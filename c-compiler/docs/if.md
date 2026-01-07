# if文を作成する
```
cond_stmt /* 条件文 */
    : IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {$$ = build_node3(IF_AST, $3, $6, $10);}
    | IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE {$$ =build_node2(IF_AST, $3, $6);}
;
```
構文は上のルールで作られる。

```json
{"STATEMENTS_AST_0": {"DECL_STATEMENTS_AST_1": {"DECL_STATEMENT_AST_2": {"IDENT_AST_3": {"value": "x"}}},"STATEMENTS_AST_4": {"STATEMENT_AST_5": {"IF_AST_6": {"GT_AST_7": {"VAR_AST_8": {"IDENT_AST_9": {"value": "x"}},"NUMBER_AST_10": {"value": 0}},"STATEMENTS_AST_11": {"STATEMENT_AST_12": {"ASSIGNMENT_STMT_AST_13": {"IDENT_AST_14": {"value": "x"},"PLUS_AST_15": {"VAR_AST_16": {"IDENT_AST_17": {"value": "x"}},"NUMBER_AST_18": {"value": 1}}}}}}}}}}
```

### IF文のAST構造（抜粋）
```json
"IF_AST_6": {
  "GT_AST_7": {
    "VAR_AST_8": {
      "IDENT_AST_9": {
        "value": "x"
      }
    },
    "NUMBER_AST_10": {
      "value": 0
    }
  },
  "STATEMENTS_AST_11": {
    "STATEMENT_AST_12": {
      "ASSIGNMENT_STMT_AST_13": {
        "IDENT_AST_14": {
          "value": "x"
        },
        "PLUS_AST_15": {
          "VAR_AST_16": {
            "IDENT_AST_17": {
              "value": "x"
            }
          },
          "NUMBER_AST_18": {
            "value": 1
          }
        }
      }
    }
  }
}
```
これを処理していく。

## コード生成を考える。
`if (e1) {s1}`

```
    $v0 = eval(e1)
    v0が0なら ja label1
    eval(s1)
label1:
```
`if (e1){s1}else{s2}`
```
    $v0 = eval(e1)
    v0が0なら ja label1
    eval(s1)
    ja label2
label1:
    eval(s2)
label2:
```
こんな感じでいけそう。

## トラブルシューティング: Thenブロックの後にElseブロックが実行される問題

### 現象
`if (cond) { ... } else { ... }` において、条件が真（True）の場合に Then ブロックが実行された後、続けて Else ブロックも実行されてしまう。

### 原因
`codegen.c` の `walk_ast` 関数において、`STATEMENTS_AST`（ブロック `{ ... }`）の専用処理がなく、`default` ラベルの処理が適用されていたことが原因。

`default` の処理は以下のようになっていた：
```c
default:
    walk_ast(n->child, fp);   // 子（ブロックの中身）を処理
    walk_ast(n->brother, fp); // 兄弟（次のノード）を処理
    break;
```

`IF_AST` の構造上、Thenブロック（`STATEMENTS_AST`）の `brother` は Elseブロック（`STATEMENTS_AST`）となっている。
そのため、Thenブロックのコード生成を行った際、`default` ルートを通ると、自動的に `brother` である Elseブロックのコード生成も行われてしまっていた。

### 解決策
`STATEMENTS_AST` 用の `case` を追加し、`brother` を辿らず `child` のみを処理するように変更する。

```c
case STATEMENTS_AST:
    // ブロック（{...}）の処理。
    // ここでは中身（child）だけを処理し、
    // brother（If文におけるElseブロックなど）には勝手に進まないようにする。
    walk_ast(n->child, fp);
    break;
```

これにより、Thenブロックの処理は「Thenブロックの中身」の生成だけで完了し、Elseブロックへの遷移制御（ジャンプ命令など）は親ノードである `IF_AST` のロジックが正しく行えるようになる。