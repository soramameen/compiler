%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror(char *s);
%}

/* トークン定義 */
%token NUMBER

/* 優先順位の定義 (下から上に優先度が高くなる) */
%left '+' '-' 
%left '*' '/' 

%%
program: expression '\n' { printf("Result: %d\n", $1); }
       ;

/* expressionの右辺をNUMBERではなくexpressionに変更 (自己参照) */
expression: NUMBER         { $$ = $1; }
          | expression '+' expression { $$ = $1 + $3; }
          | expression '-' expression { $$ = $1 - $3; }
          | expression '*' expression { $$ = $1 * $3; }
          | expression '/' expression { 
              if ($3 == 0) {
                  fprintf(stderr, "Error: division by zero\n");
                  YYABORT; 
              }
              $$ = $1 / $3;
            }
          ;
%%

/* ... (以下省略) ... *//* エラー処理関数 */
int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

/* main関数 (yacc/bisonが構文解析を開始する) */
int main() {
    printf("> ");
    yyparse();
    return 0;
}
