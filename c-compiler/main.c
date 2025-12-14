// main.c
#include "ast.h"
#include <stdio.h>
#include <codegen.h>
Node* top = NULL; // yyparse() が結果を格納するグローバル変数

int main(void) {
    // パーサーを呼び出してASTを構築
    if(yyparse() != 0){
        fprintf(stderr, "Parse failed.\n");
        return 1;
    }

    // ASTが構築されていればJSON形式で表示 1：デバッグモード
    if (0){
      if (top != NULL) {
          printf("[*] AST generation is completed\n");
          print_tree_in_json(top);
          printf("\n");
      }
    }
    if (top != NULL){
        generate_code(top, stdout);
    }

    return 0;
}
