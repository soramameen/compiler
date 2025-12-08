%{
#include <stdio.h>
#include "ast.h"

extern Node *top; /* ast.c で定義したルートノード */
extern int yylex();
extern void yyerror(char *s);
%}

/* ▼ 型定義: ノード(np)を使うことを宣言 */
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

program
    : expression {
        /* 計算結果(expression)をプログラム全体のルートにする */
        top = build_node1(PROGRAM_AST, $1);
    }
;

expression
    : expression PLUS term {
        /* ★ここで足し算のノードを作る！ */
        /* 左の式($1) + 右の項($3) */
        $$ = build_node2(ADD_AST, $1, $3);
    }
    | expression MINUS term {
        $$ = build_node2(MINUS_AST, $1, $3);
    }
    | term {
        /* 足し算じゃない場合、そのままスルー */
        $$ = $1;
    }
;

term
    : term MUL factor {
        $$ = build_node2(MUL_AST, $1, $3);
    }
    | term DIV factor {
        $$ = build_node2(DIV_AST, $1, $3);
    }
    | factor {
        $$ = $1
    }
;

factor
    : NUMBER {
        /* 数字の葉っぱを作る */
        /* 本当は数値を保存するけど、今は形でOK */
        $$ = build_node0(NUMBER_AST);
    }
;

%%
