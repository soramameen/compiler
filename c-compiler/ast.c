#include "ast.h"

Node *top;

Node *build_node0(NType t){
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p== NULL){
      yyerror("out of memory");
    }
    p->type = t;
    p->child = NULL;
    return p;
}
Node *build_node1(NType t, Node *p1){
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p== NULL){
      yyerror("out of memory");
    }
    p->type = t;
    p->child = p1;
    return p;
}
Node *build_node2(NType t, Node *p1, Node *p2){
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p== NULL){
      yyerror("out of memory");
    }
    p->type = t;
    p->child = p1;
    p->child->brother = p2;
    return p;
}

Node* build_node3(NType t, Node* p1, Node* p2, Node* p3){
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p== NULL){
      yyerror("out of memory");
    }
    p->type = t;
    p->child = p1;
    p->child->brother = p2;
    p->child->brother-> brother = p3;
    return p;
}

Node *build_num_node(int n) {
    Node* p = build_node0(NUMBER_AST);
    p->val.ival = n;
    return p;
}

Node *build_ident_node(char* s) {
    Node* p = build_node0(IDENT_AST);
    p->val.sval = s;
    return p;
}

void print_node_type(int node_type) {
    printf("Node type: %s\n",node_types[node_type]);
}
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
char *node_types[] = {
    "IDENT_AST",
    "IDENTS_AST",
    "STATEMENTS_AST",
    "STATEMENT_AST",
    "DECL_STATEMENT_AST",
    "DECL_STATEMENTS_AST",
    "ASSIGNMENT_STMT_AST",
    "STR_AST",
    "NUMBER_AST",
    "EXPRESSION_AST",
    "ADD_OP_AST",
    "PLUS_AST",
    "MINUS_AST",
    "TERM_AST",
    "FACTOR_AST",
    "MUL_AST",
    "DIV_AST",
    "OP_PLUS",
    "OP_MINUS",
    "OP_MUL",
    "OP_DIV",
    "VAR_AST",
    "EQ_AST",
    "NE_AST",
    "LE_AST",
    "GE_AST",
    "LT_AST",
    "GT_AST",
    "OP_EQ", 
    "OP_NE",
    "OP_LE",
    "OP_GE",
    "OP_LT",
    "OP_GT",
    "WHILE_AST",
    "IF_AST",
};
void print_tree_in_json(Node *n){
    if (n!=NULL){
      int num =0;
      printf("{");
      print_tree(n,num);
      printf("}");
    }
}

int print_tree(Node *n, int num){
    printf("\"%s_%d\": {", node_types[n->type], num++);
    if(n->type == NUMBER_AST) {
        printf("\"value\": %d", n->val.ival);
        if (n->child != NULL) printf(", "); 
    }
    else if (n->type == IDENT_AST) { 
      printf("\"value\": \"%s\"", n->val.sval);
      if (n->child != NULL) printf(", ");
    }

    if (n->child != NULL) {
      num = print_tree(n->child, num);
    }
    printf("}");
    if(n->brother != NULL) {
      printf(",");
      num = print_tree(n->brother,num);
    }
    return num;
}
      

#if 0
int main(void) {
    if(yyparse()){
        fprintf(stderr, "Error!\n");
        return 1;
    }

    printf("[*] AST generation is completed\n");
    print_tree_in_json(top);
    printf("\n");
    return 0;
}
#endif

