#ifndef AST_SIMPLE_H
#define AST_SIMPLE_H
#include <stdio.h> 
#include <stdlib.h>

typedef enum{
    IDENT_AST=0,
    IDENTS_AST,
    NUMBER_AST,
    STATEMENTS_AST,
    STATEMENT_AST,
} NType;

typedef struct node{
  NType type;
  struct node* child;
  struct node* brother;
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
#endif
