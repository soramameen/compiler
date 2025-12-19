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
    
    
