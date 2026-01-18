/* ast.c */
#include "ast.h"

/* yaccの関数を宣言 */
extern int yyparse();
void yyerror(char *s);

/* 表示用文字列 */
char *node_types[] = {
    "IDENT_AST",
    "IDENTS_AST",
    "NUMBER_AST",
    "STATEMENTS_AST",
    "STATEMENT_AST",
    "ADD_AST",
    "MINUS_AST",
    "MUL_AST",
    "DIV_AST",
    "PROGRAM_AST",
};

/* 完成した木のルートを保存する変数 */
Node *top = NULL;

/* ノード生成 (子供なし) */
Node *build_node0(NType t) {
    Node *p = (Node *)malloc(sizeof(Node));
    if (p == NULL) yyerror("out of memory");
    p->type = t;
    p->child = NULL;
    p->brother = NULL;
    return p;
}

/* ノード生成 (子供1つ) */
Node *build_node1(NType t, Node *p1) {
    Node *p = (Node *)malloc(sizeof(Node));
    if (p == NULL) yyerror("out of memory");
    p->type = t;
    p->child = p1;
    p->brother = NULL;
    return p;
}

Node *build_node2(NType t, Node *p1, Node *p2) {
    Node *p = (Node *)malloc(sizeof(Node));
    if (p == NULL) yyerror("out of memory");
    p->type = t;
    p->child = p1;
    if (p1 != NULL) {
        p1->brother = p2;
    }
    p->brother = NULL;
    return p;
}

Node *build_num_node(int n) {
    Node *p = (Node *)malloc(sizeof(Node));
    p->type = NUMBER_AST;
    p->ival = n;
    return p;
}

/* 再帰的に木をJSON形式で表示する関数 [cite: 314-325] */
int print_tree(Node *n, int num) {
    printf("\"%s_%d\": {", node_types[n->type], num++);
    if (n->type == NUMBER_AST) {
        printf("\"value\": %d, ", n->ival);
    }
    if (n->child != NULL) {
        num = print_tree(n->child, num);
    }
    printf("}");

    if (n->brother != NULL) {
        printf(",");
        num = print_tree(n->brother, num);
    }
    return num;
}

void print_tree_in_json(Node *n) {
    if (n != NULL) {
        printf("{");
        print_tree(n, 0);
        printf("}\n");
    }
}
// ---------------------------- 
// main関数
// ----------------------------
int main(void) {
    if (yyparse()) {
        fprintf(stderr, "Error!\n");
        return 1;
    }
    printf("[*] AST generation is completed\n");
    
    print_tree_in_json(top);
    
    return 0;
}
