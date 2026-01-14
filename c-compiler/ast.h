#ifndef AST_H
#define AST_H
#include <stdio.h> 
#include <stdlib.h>

typedef enum{
    IDENT_AST=0,
    IDENTS_AST,
    STATEMENTS_AST,
    STATEMENT_AST,
    DECL_STATEMENT_AST,
    ARRAY_DECL_STATEMENT_AST,
    DECL_STATEMENTS_AST,
    ASSIGNMENT_STMT_AST,
    STR_AST,
    NUMBER_AST,
    EXPRESSION_AST,
    ADD_OP_AST,
    PLUS_AST,
    MINUS_AST,
    TERM_AST,
    FACTOR_AST,
    MUL_AST,
    DIV_AST,
    OP_PLUS,
    OP_MINUS,
    OP_MUL,
    OP_DIV,
    VAR_AST,
    EQ_AST,
    NE_AST,
    LE_AST,
    GE_AST,
    LT_AST,
    GT_AST,
    OP_EQ,
    OP_NE,
    OP_LE,
    OP_GE,
    OP_LT,
    OP_GT,
    WHILE_AST,
    IF_AST,
} NType;

typedef struct node{
  NType type;
  struct node* child;
  struct node* brother;
  union {
    int ival;
    char *sval;
  } val;
} Node;

extern char *node_types[];
extern int yyparse();
void print_node_type(int node_type);
void print_tree_in_json(Node *n);
int print_tree(Node *n,int num);
void yyerror(const char *s);
Node *build_node0(NType t);
Node *build_node1(NType t, Node *p1);
Node *build_node2(NType t, Node *p1, Node *p2);
Node* build_node3(NType t, Node* p1, Node* p2, Node* p3);
Node* build_num_node(int n);
Node* build_ident_node(char* s);
#endif
