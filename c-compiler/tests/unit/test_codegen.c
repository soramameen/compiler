// test_codegen.c
#include "ast.h"
#include "codegen.h"
#include <stdio.h>

// コンパイルエラーを回避するためのダミー関数
int yyparse() { return 0; }

int main() {
    // 単純に42を返すだけのAST
    Node *test_ast = build_node1(STATEMENT_AST, build_num_node(42));

    // コード生成関数を呼び出す
    generate_code(test_ast, stdout);

    return 0;
}
