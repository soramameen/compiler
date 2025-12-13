// test_codegen.c
#include "ast.h"      // Node構造体やbuild_node系の関数を使うため
#include "codegen.h"  // これから作るgenerate_code関数を使うため
#include <stdio.h>

// コンパイルエラーを回避するためのダミー関数
int yyparse() { return 0; }

int main() {
    printf("--- Codegen Test ---\n");
    printf("Input: 3 + 5\n");
    printf("Output Assembly:\n\n");

    // 1. 「3 + 5」という式を表すASTノードを手動で作成
    Node *test_ast = build_node1(STATEMENTS_AST,
                                 build_node1(STATEMENT_AST,
                                             build_node2(PLUS_AST,
                                                         build_num_node(3), // 左の子: 3
                                                         build_num_node(5)  // 右の子: 5
                                                        )));

    // 2. 作成したASTを引数にして、コード生成関数を呼び出す
    //    結果は標準出力(stdout)に出力する
    generate_code(test_ast, stdout);

    // メモリ解放処理は、テストが単純なうちは省略してOK
    return 0;
}

