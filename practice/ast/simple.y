%{
#include <stdio.h>
#include "ast_simple.h"

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

%type <np> statements statement idents
%define parse.error verbose

%left PLUS
%left MUL


%%

/* --- 文法規則 --- */
statements
  :   statement statements{ top = build_node2(STATEMENTS_AST, $1, top);}
  |   statement{top = build_node1(STATEMENTS_AST, $1);}
;
statement
  :   DEFINE idents SEMIC {$$ = build_node1(STATEMENTS_AST, $2);}
  |   IDENT ASSIGN NUMBER SEMIC {$$ = build_node2(STATEMENT_AST,build_node0(IDENT_AST), build_node0(NUMBER_AST));}
;
idents
  :   IDENT COMMA idents {$$ = build_node2(IDENTS_AST, build_node0(IDENT_AST), $3);}
  |   IDENT              {$$ = build_node1(IDENTS_AST,build_node0(IDENT_AST));}

;
%%
