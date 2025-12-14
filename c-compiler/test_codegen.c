// test_codegen.c
#include "ast.h"
#include "codegen.h"
#include <stdio.h>

// コンパイルエラーを回避するためのダミー関数
int yyparse() { return 0; }

int main() {
    printf("--- Codegen Test for While Loop ---\n");
    printf("Input: define i; define sum; sum=0; i=1; while(i<11){sum=sum+i; i=i+1;} sum;\n");
    printf("Expected exit code: 55\n");
    printf("Output Assembly:\n\n");

    // --- ASTを手動で構築 ---

    // --- 宣言部 ---
    Node *decls = build_node2(DECL_STATEMENTS_AST,
                              build_node1(DECL_STATEMENT_AST, build_ident_node("i")),
                              build_node1(DECL_STATEMENT_AST, build_ident_node("sum")));

    // --- 実行文部 ---
    // sum = 0;
    Node *assign_sum_0 = build_node2(ASSIGNMENT_STMT_AST, build_ident_node("sum"), build_num_node(0));
    // i = 1;
    Node *assign_i_1 = build_node2(ASSIGNMENT_STMT_AST, build_ident_node("i"), build_num_node(1));

    // --- while ループ ---
    // 条件: i < 11
    Node *condition = build_node2(LT_AST, build_node1(VAR_AST, build_ident_node("i")), build_num_node(11));
    
    // 本体: { sum = sum + i; i = i + 1; }
    // sum = sum + i
    Node *sum_plus_i = build_node2(PLUS_AST, build_node1(VAR_AST, build_ident_node("sum")), build_node1(VAR_AST, build_ident_node("i")));
    Node *assign_sum = build_node2(ASSIGNMENT_STMT_AST, build_ident_node("sum"), sum_plus_i);
    // i = i + 1
    Node *i_plus_1 = build_node2(PLUS_AST, build_node1(VAR_AST, build_ident_node("i")), build_num_node(1));
    Node *assign_i = build_node2(ASSIGNMENT_STMT_AST, build_ident_node("i"), i_plus_1);
    
    Node *loop_body = build_node2(STATEMENTS_AST,
                                  build_node1(STATEMENT_AST, assign_sum),
                                  build_node1(STATEMENT_AST, assign_i));

    Node *while_loop = build_node2(WHILE_AST, condition, loop_body);

    // 最終的に sum の値を返すための文
    Node *return_sum = build_node1(STATEMENT_AST, build_node1(VAR_AST, build_ident_node("sum")));

    // 全ての文をまとめる
    Node *stmts = build_node2(STATEMENTS_AST,
                              build_node1(STATEMENT_AST, assign_sum_0),
                              build_node2(STATEMENTS_AST,
                                          build_node1(STATEMENT_AST, assign_i_1),
                                          build_node2(STATEMENTS_AST,
                                                      build_node1(STATEMENT_AST, while_loop),
                                                      return_sum)));

    // 宣言部と実行文部をまとめる
    Node *test_ast = build_node2(STATEMENTS_AST, decls, stmts);

    // コード生成関数を呼び出す
    generate_code(test_ast, stdout);

    return 0;
}