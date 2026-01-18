#ifndef CODEGEN_H
#define CODEGEN_H

#include "ast.h"
#include <stdio.h>

// ASTのルートノードと出力ファイルを受け取り、コード生成を開始する
void generate_code(Node *root, FILE *fp);

#endif
