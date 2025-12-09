%{
#include <stdio.h>
#include "ast.h"

// extern Node *top; 
extern int yylex();
extern void yyerror(const char *s);
extern Node* top;
%}

%union {
    struct node *np;
    int num;
    char *str;
}
/* トークン定義 */
%token ASSIGN SEMIC DEFINE COMMA  <num>NUMBER <str>IDENT

%token EQ NE LE GE LT GT

%token  PLUS MINUS MUL DIV

%token L_PAREN R_PAREN L_BRACE R_BRACE L_BRACKET R_BRACKET

%token ARRAY WHILE FOR IF ELSE

%type <np> program declarations decl_statement statements statement assignment_stmt 
%define parse.error verbose

%left PLUS
%left MUL

%%

/* --- 文法規則 --- */
program /*プログラム*/
    : declarations statements {top = build_node2(STATEMENTS_AST,$1, $2);}
;

declarations /*変数宣言部*/
    : decl_statement declarations { $$ = build_node2(DECL_STATEMENTS_AST,$1, $2);}
    | decl_statement { $$ = build_node1(DECL_STATEMENTS_AST, $1);}
;
decl_statement /*宣言文*/
    : DEFINE IDENT SEMIC { $$ = build_node1(DECL_STATEMENT_AST, build_node0(STR_AST));}

statements
    : statement statements {$$ = build_node2(STATEMENTS_AST,$1,$2);}
    | statement {$$ = build_node1(STATEMENTS_AST,$1);}
;
statement
    : assignment_stmt {$$ = build_node1(STATEMENT_AST, $1);}
;

assignment_stmt
    :IDENT ASSIGN NUMBER SEMIC {$$ =build_node2(ASSIGNMENT_STMT_AST,build_node0(STR_AST),build_node0(NUMBER_AST));}
;


%%
