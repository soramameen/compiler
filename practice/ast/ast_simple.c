#include "ast_simple.h"

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



void print_node_type(int node_type) {
    printf("Node type: %s\n",node_types[node_type]);
}
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
char *node_types[] = {
    "INDENT_AST",
    "IDENTS_AST",
    "NUMBER_AST",
    "STATEMENTS_AST",
    "STATEMENT_AST",
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
