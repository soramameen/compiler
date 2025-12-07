/* ast.h */
#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>

/* ノードの種類 */
typedef enum {
    IDENT_AST = 0,
    IDENTS_AST,
    NUMBER_AST,
    STATEMENTS_AST,
    STATEMENT_AST,
    ADD_AST,
    MINUS_AST,
    MUL_AST,
    PROGRAM_AST
} NType;

/* ノード構造体 (ここでリスト構造を定義) */
typedef struct node {
    NType type;
    struct node *child;   /* 子供 (リストの先頭) */
    struct node *brother; /* 兄弟 (リストの続き) */
} Node;

/* プロトタイプ宣言 */
Node *build_node0(NType t);
Node *build_node1(NType t, Node *p1);
Node *build_node2(NType t, Node *p1, Node *p2);
void print_node_type(int node_type);
void print_tree_in_json(Node *n);

/* グローバル変数 */
extern char *node_types[];
extern Node *top;

#endif
