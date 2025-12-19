#include "codegen.h"
#include "symbol_table.h"
static int while_loop_count = 0;
static void push(const char* reg, FILE*fp){
    fprintf(fp,"  sw %s, -4($sp)\n",reg);
    fprintf(fp,"  addi $sp, $sp, -4\n");
}
static void pop(const char* reg, FILE *fp){
    fprintf(fp,"  lw %s, 0($sp)\n", reg);
    fprintf(fp,"  addi $sp, $sp, 4\n");
}

static void nop(FILE *fp){
    fprintf(fp,"  nop\n");
}
static void find_declarations(Node* n){
    if(n == NULL) return;

    if(n->type == DECL_STATEMENT_AST){
      char* var_name = n->child->val.sval;
      symbol_table_add(var_name);
    }
    find_declarations(n->child);
    find_declarations(n->brother);
}
// ASTを再帰的に辿る関数のプロトタイプ宣言
static void walk_ast(Node *n, FILE *fp);

// ASTを辿ってコード生成する本体
static void walk_ast(Node *n, FILE *fp) {
    if (n == NULL) return;

    char* var_name;
    int offset;
    switch (n->type) {
        case ASSIGNMENT_STMT_AST:
            // 右辺を読み込む
            walk_ast(n->child->brother,fp);
            var_name = n->child->val.sval;
            offset = symbol_table_get_address(var_name);
            fprintf(fp,"  sw $v0, %d($fp)\n",offset);
            break;

        case WHILE_AST:
            {
                int current_label_num = while_loop_count;
                while_loop_count++;

                fprintf(fp, "$WHILE_LOOP_START_%d:\n", current_label_num);
                walk_ast(n->child, fp);
                fprintf(fp, "  beq $v0, $zero, $WHILE_LOOP_END_%d\n", current_label_num);
                nop(fp); 
                walk_ast(n->child->brother, fp);
                fprintf(fp, "  j $WHILE_LOOP_START_%d\n", current_label_num);
                nop(fp); 
                fprintf(fp, "$WHILE_LOOP_END_%d:\n", current_label_num);
            }
            break;
        case IF_AST:
            // v0にe1を評価した後の値が入る。
            walk_AST(n->child,fp);
            

            


        case VAR_AST:
            var_name = n->child->val.sval;
            offset = symbol_table_get_address(var_name);
            fprintf(fp,"  lw $v0, %d($fp)\n", offset);
            nop(fp); 
            break;    

        case NUMBER_AST:
            // 数値の場合: v0レジスタに数値をロード
            fprintf(fp, "  li $v0, %d\n", n->val.ival);
            break;

        case PLUS_AST:
            walk_ast(n->child->brother,fp);
            push("$v0", fp);
            walk_ast(n->child,fp);
            pop("$v1",fp);
            fprintf(fp,"  add $v0, $v0, $v1\n");
            break;

        case MINUS_AST:
            walk_ast(n->child->brother,fp);
            push("$v0", fp);
            walk_ast(n->child,fp);
            pop("$v1",fp);
            fprintf(fp,"  sub $v0, $v0, $v1\n");
            break;

         case MUL_AST:
            walk_ast(n->child->brother,fp);
            push("$v0", fp);
            walk_ast(n->child,fp);
            pop("$v1",fp);
            fprintf(fp,"  mult $v0, $v1\n");
            fprintf(fp,"  mflo $v0\n");
            break;

         case DIV_AST:
            walk_ast(n->child->brother,fp);
            push("$v0", fp);
            walk_ast(n->child,fp);
            pop("$v1",fp);
            fprintf(fp,"  div $v0, $v1\n");
            fprintf(fp,"  mflo $v0\n");
             break;
        /* a < b true->1, false->0 */ 
        case LT_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             fprintf(fp,"   slt $v0, $v0, $v1\n");
             break;
        case DECL_STATEMENT_AST:
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
    symbol_table_init();
    while_loop_count = 0; 
    find_declarations(root);

    // --- ヘッダ (init, stop ブロック) ---
    fprintf(fp, "INITIAL_GP = 0x10008000\n");
    fprintf(fp, "INITIAL_SP = 0x7ffffffc\n");
    fprintf(fp, "stop_service = 99\n\n");
    fprintf(fp, ".text\n");
    fprintf(fp, "init:\n");
    fprintf(fp, "  la $gp, INITIAL_GP\n");
    fprintf(fp, "  la $sp, INITIAL_SP\n");
    fprintf(fp, "  jal main\n");
    nop(fp);
    fprintf(fp, "  add $a0, $v0, $zero\n");
    fprintf(fp, "  li $v0, stop_service\n");
    fprintf(fp, "  syscall\n");
    nop(fp);
    fprintf(fp, "stop:\n");
    fprintf(fp, "  j stop\n");
    nop(fp);
    fprintf(fp, "\n");

    // --- main 関数 ---
    fprintf(fp, ".text\n");
    fprintf(fp, "main:\n");
    
    // --- 関数開始処理 ---
    int frame_size = symbol_table_get_total_size() + 8; // 変数領域 + $ra, $fp の保存領域
    fprintf(fp, "  addiu $sp, $sp, -%d\n", frame_size);
    fprintf(fp, "  sw $ra, %d($sp)\n", frame_size - 4);
    fprintf(fp, "  sw $fp, %d($sp)\n", frame_size - 8);
    fprintf(fp, "  addiu $fp, $sp, %d\n", frame_size);

    // --- ASTからメインのコードを生成 ---
    walk_ast(root, fp);

    // --- 関数終了処理 ---
    fprintf(fp, "  lw $ra, %d($sp)\n", frame_size - 4);
    nop(fp); 
    fprintf(fp, "  lw $fp, %d($sp)\n", frame_size - 8);
    nop(fp); 
    fprintf(fp, "  addiu $sp, $sp, %d\n", frame_size);
    fprintf(fp, "  jr $ra\n");
    nop(fp); 
}
