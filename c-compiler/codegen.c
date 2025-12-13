#include "codegen.h"

static void push(const char* reg, FILE*fp){
    fprintf(fp,"  sw %s, -4($sp)\n",reg);
    fprintf(fp,"  addi $sp, $sp, -4\n");
}
static void pop(const char* reg, FILE *fp){
    fprintf(fp,"  lw %s, 4($sp)\n", reg);
    fprintf(fp,"  addi $sp, $sp, 4\n");
}

static void nop(FILE *fp){
    fprintf(fp,"  nop\n");
}
// ASTを再帰的に辿る関数のプロトタイプ宣言
static void walk_ast(Node *n, FILE *fp);

// ASTを辿ってコード生成する本体
static void walk_ast(Node *n, FILE *fp) {
    if (n == NULL) return;

    switch (n->type) {
        case NUMBER_AST:
            // 数値の場合: v0レジスタに数値をロード
            fprintf(fp, "  li $v0, %d\n", n->val.ival);
            break;

        // ここに PLUS_AST, ASSIGNMENT_STMT_AST などを追加していく
        case PLUS_AST:
            walk_ast(n->child->brother,fp);
            
            push("$v0", fp);
            walk_ast(n->child,fp);
            pop("$v1",fp);
            fprintf(fp,"  add $v0, $v0, $v1\n");
            break;
        default:
            // 子と兄弟を再帰的に辿る
            walk_ast(n->child, fp);
            walk_ast(n->brother, fp);
            break;
    }
}

// コード生成を開始するメイン関数
void generate_code(Node *root, FILE *fp) {
    // --- アセンブリのヘッダ部分 ---
    fprintf(fp, ".text\n");
    fprintf(fp, ".globl main\n");
    fprintf(fp, "main:\n");
    // スタックフレームを設定
    fprintf(fp, "  move $fp, $sp\n");

    // --- ASTからメインのコードを生成 ---
    walk_ast(root, fp);

    // --- プログラム終了処理 ---
    // 最後の計算結果($v0)を終了コードとして返す
    // MIPSのシステムコール:
    // 1 (print_int): a0レジスタの整数を表示
    // 17 (exit2): a0レジスタの値を終了コードとする
    fprintf(fp, "  move $a0, $v0\n"); // 返したい値を$a0にコピー
    fprintf(fp, "  li $v0, 17\n");   // exit2システムコール
    fprintf(fp, "  syscall\n\n");
}
