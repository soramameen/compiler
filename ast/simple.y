%{
#include <stdio.h>
#include "ast.h"

extern Node *top; 
extern int yylex();
extern void yyerror(char *s);
%}

%union {
    struct node *np;
    int num;
    char *str;
}
/* トークン定義 */
%token ASSIGN SEMIC DEFINE  <num>NUMBER <str>IDENT

%token EQ NE LE GE LT GT

%token  PLUS MINUS MUL DIV

%token L_PAREN R_PAREN L_BRACE R_BRACE L_BRACKET R_BRACKET

%token ARRAY WHILE FOR IF ELSE

%left PLUS
%left MUL

/* ▼ 非終端記号はすべてノード(np)型にする */
%type <np> program expression term factor

%%

/* --- 文法規則 --- */
statements
  :   statement statements
  |   statement
;
statement
  :   DEFINE idents SEMIC {printf("Define OK!\n");}
  |   IDENT ASSIGN NUMBER SEMIC {printf("OK!indent=%s, num=%d\n", $1, $3);}
;
idents
  :   IDENT COMMA idents {printf("OK! new ident=%s\n", $1);}
  |   IDENT              {printf("OK! new ident=%s\n", $1);}
;
%%
