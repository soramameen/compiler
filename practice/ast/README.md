# todo

- [] 複数の識別子を宣言できるようにする   

# 実装メモ

## num_nodeとindent_nodeを作成する

現在のNodeには値を保存する場所がないため、Node構造体を変更する必要がある。

1. Unionを追加する

```c
       // ast.h
    typedef struct Node {
        NType type;
        struct Node *child;
        struct Node *brother;
        union {
            int ival;    // 数値用
            char *sval;  // 識別子文字列用
        } val;
    } Node;
    
    // 実装関数
    Node *build_num_node(int n) {
        Node *p = build_node0(NUMBER_AST);
        p->val.ival = n;
        return p;
    }
    Node *build_ident_node(char *s) {
        Node *p = build_node0(IDENTS_AST);
        p->val.sval = strdup(s); // 文字列をコピー
        return p;
    }
```

2. 擬似継承を行う。
3. voidポインタを使う。
    後でキャストが面倒。polymorphicのような考え方なので難しそう。
