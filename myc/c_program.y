%{
  #include <stdio.h>
  #include "c_program.tab.h"
  extern int yylex();
  extern int yyerror();
%}

%union{
  int num;
  char* str;	
}

%token ASSIGN SEMIC DEFINE  <num>NUMBER <str>IDENT

%token EQ LT GT LE GE NE

%token  PLUS MINUS MUL DIV

%token L_PAREN R_PAREN L_BRACE R_BRACE L_BRACKET R_BRACKET

%token ARRAY WHILE IF ELSE

%%

program /* プログラム */
    : declarations statements
;

declarations /* 変数宣言部 */
    : decl_statement declarations
    | decl_statement
;
decl_statement /* 宣言文 */
    : DEFINE IDENT SEMIC {printf("OK! ident=%s\n",$2);}
    | ARRAY IDENT L_BRACKET NUMBER R_BRACKET SEMIC {printf("OK! array ident=%s size=%d\n",$2,$4);}
;
statements /* 文集合 */
    : statement statements
    | statement
;

statement /* 文 */
    : assignment_stmt
    | loop_stmt
    | cond_stmt
;

assignment_stmt /* 代入文 */
    : IDENT ASSIGN expression SEMIC
    | IDENT L_BRACKET expression R_BRACKET ASSIGN expression SEMIC
;

expression /* 算術式 */
    : expression add_op term
    | term
;

term /* 項 */
    : term mul_op factor
    | factor
;

factor /* 因子 */
    : var 
    | L_PAREN expression R_PAREN
;

add_op /* 加減演算子*/
    : PLUS
    | MINUS
;
mul_op /* 乗除演算子 */
    : MUL
    | DIV
;

var /* 変数 */
    : IDENT
    | NUMBER
    | IDENT L_BRACKET expression R_BRACKET
;

loop_stmt /* ループ文 */
    : WHILE L_PAREN condition R_PAREN L_BRACE statements R_BRACE
;

cond_stmt /* 条件文 */
    : IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE
    | IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE
;

condition /* 条件式 */
    : expression cond_op expression
;

cond_op /* 比較演算子 */
    : EQ
    | NE
    | LE
    | GE
    | LT
    | GT
;



%%

int main(void) {
  if(yyparse()){
    fprintf(stderr, "Error!\n");
    return 1;
  }
  return 0;
}
