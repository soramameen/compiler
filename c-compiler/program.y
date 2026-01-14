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

%type <np> program declarations decl_statement statements statement assignment_stmt expression term factor var condition loop_stmt cond_stmt
%define parse.error verbose
%type <num> add_op mul_op cond_op
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
    : DEFINE IDENT SEMIC { $$ = build_node1(DECL_STATEMENT_AST, build_ident_node($2));}
    | ARRAY IDENT L_BRACKET NUMBER R_BRACKET SEMIC { $$ = build_node2(ARRAY_DECL_STATEMENT_AST, build_ident_node($2), build_num_node($4));}
    | ARRAY IDENT L_BRACKET NUMBER R_BRACKET L_BRACKET NUMBER R_BRACKET SEMIC { $$ = build_node3(ARRAY_DECL_STATEMENT_AST, build_ident_node($2), build_num_node($4), build_num_node($7))};

statements
    : statement statements {$$ = build_node2(STATEMENTS_AST,$1,$2);}
    | statement {$$ = build_node1(STATEMENTS_AST,$1);}
;
statement
    : assignment_stmt {$$ = build_node1(STATEMENT_AST, $1);}
    | loop_stmt { $$ = build_node1(STATEMENT_AST,$1);}
    | cond_stmt { $$ = build_node1(STATEMENT_AST,$1);}
    | expression SEMIC {$$ = build_node1(STATEMENT_AST, $1);}
;

assignment_stmt /* 代入文 */
    :IDENT ASSIGN expression SEMIC {$$ =build_node2(ASSIGNMENT_STMT_AST,build_ident_node($1),$3);}

;

expression /* 算術式 */
    : expression add_op term {
          if ($2 == OP_PLUS) {
              $$ = build_node2(PLUS_AST, $1, $3);
          }
          else {
              $$ = build_node2(MINUS_AST, $1, $3);
          }
      }

    | term {$$ = $1;}
;

term /* 項 */
    : term mul_op factor {
          if ($2 == OP_MUL) {
              $$ = build_node2(MUL_AST, $1, $3);
          }
          else {
              $$ = build_node2(DIV_AST, $1, $3);
          }
      }

    | factor {$$ = $1;}
;

factor /* 因子 */
    : var {$$ = $1;}
    | NUMBER {$$ = build_num_node($1);}
    | L_PAREN expression R_PAREN {$$ = $2;}
;

add_op /* 加減演算子 */
    : PLUS {$$ = OP_PLUS;}
    | MINUS {$$ = OP_MINUS;}
;

mul_op /* 乗除演算子 */
    : MUL {$$ = OP_MUL;}
    | DIV {$$ = OP_DIV;}
;

var /* 変数 */
    : IDENT { $$ = build_node1(VAR_AST,build_ident_node($1));}
;

loop_stmt /* ループ文 */
    : WHILE L_PAREN condition R_PAREN L_BRACE statements R_BRACE { $$ = build_node2(WHILE_AST,$3, $6);} 
;

cond_stmt /* 条件文 */
    : IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {$$ = build_node3(IF_AST, $3, $6, $10);}
    | IF L_PAREN condition R_PAREN L_BRACE statements R_BRACE {$$ =build_node2(IF_AST, $3, $6);}
;    
condition /* 条件式 */
    : expression cond_op expression {
      if ($2 == OP_EQ) {
          $$ = build_node2(EQ_AST, $1, $3);}
      else if ($2 == OP_NE) {
          $$ = build_node2(NE_AST, $1, $3);}
      else if ($2 == OP_LE) {
          $$ = build_node2(LE_AST, $1, $3);}
      else if ($2 == OP_GE) {
          $$ = build_node2(GE_AST, $1, $3);}
      else if ($2 == OP_LT) {
          $$ = build_node2(LT_AST, $1, $3);}
      else if ($2 == OP_GT) {
          $$ = build_node2(GT_AST, $1, $3);}
    }
;

cond_op /* 比較演算子 */
    : EQ { $$ = OP_EQ; }
    | NE { $$ = OP_NE; }
    | LE { $$ = OP_LE; }
    | GE { $$ = OP_GE; }
    | LT { $$ = OP_LT; }
    | GT { $$ = OP_GT; }
;    



%%
