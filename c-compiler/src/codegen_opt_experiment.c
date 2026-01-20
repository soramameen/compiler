#include "codegen.h"
#include "symbol_table.h"
#include <string.h>
static int while_loop_count = 0;
static int if_count = 0;
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
    else if(n->type == ARRAY_DECL_STATEMENT_AST){
      if(n->child->brother->brother != NULL){
        // 2次元配列: array arr[3][4];
        char* arr_name = n->child->val.sval;
        int rows = n->child->brother->val.ival;
        int cols = n->child->brother->brother->val.ival;
        symbol_table_add_array_2d(arr_name, rows, cols);
      } else {
        // 1次元配列: array arr[10];
        char* arr_name = n->child->val.sval;
        int size = n->child->brother->val.ival;
        symbol_table_add_array(arr_name, size);
      }
    }
    find_declarations(n->child);
    find_declarations(n->brother);
}
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
            
            // 【実験用最適化】 i->$t0, sum->$t1 に割り当て
            if (strcmp(var_name, "i") == 0) {
                fprintf(fp, "  add $t0, $v0, $zero\n"); // move $t0, $v0
            } else if (strcmp(var_name, "sum") == 0) {
                fprintf(fp, "  add $t1, $v0, $zero\n"); // move $t1, $v0
            } else {
                offset = symbol_table_get_address(var_name);
                fprintf(fp,"  sw $v0, %d($fp)\n",offset);
            }
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
            {
                if_count ++;
                int current_if = if_count;
                // 評価
                walk_ast(n->child, fp);
                // then
                Node *then_stmt = n->child->brother;
                // else
                Node *else_stmt = then_stmt->brother;

                if (else_stmt != NULL) {
                    // if-else
                    fprintf(fp, "  beq $v0, $zero, $IF_ELSE_%d\n", current_if);
                    // 遅延分岐スロット
                    nop(fp);
                    // Then
                    walk_ast(then_stmt, fp);
                    fprintf(fp, "  j $IF_END_%d\n", current_if);
                    // 遅延分岐スロット
                    nop(fp);

                    // Else
                    fprintf(fp, "$IF_ELSE_%d:\n", current_if);
                    walk_ast(else_stmt, fp);
                    
                    fprintf(fp, "$IF_END_%d:\n", current_if);
                } else {
                    // if
                    fprintf(fp, "  beq $v0, $zero, $IF_END_%d\n", current_if);
                    // 遅延分岐スロット
                    nop(fp);
                    // Then
                    walk_ast(then_stmt, fp);
                    // 終了ラベル
                    fprintf(fp, "$IF_END_%d:\n", current_if);
                }
            }
            break;

        case VAR_AST:
            var_name = n->child->val.sval;
            
            // 【実験用最適化】 i->$t0, sum->$t1 に割り当て
            if (strcmp(var_name, "i") == 0) {
                fprintf(fp, "  add $v0, $t0, $zero\n"); // move $v0, $t0
            } else if (strcmp(var_name, "sum") == 0) {
                fprintf(fp, "  add $v0, $t1, $zero\n"); // move $v0, $t1
            } else {
                offset = symbol_table_get_address(var_name);
                fprintf(fp,"  lw $v0, %d($fp)\n", offset);
                nop(fp); 
            }
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

        /* a > b true->1, false->0 */
        case GT_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             fprintf(fp,"   slt $v0, $v1, $v0\n");
             break;

        /* a == b true->1, false->0 */
        case EQ_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             fprintf(fp,"   sub $v0, $v0, $v1\n");
             nop(fp);
             fprintf(fp,"   sltiu $v0, $v0, 1\n");
             break;

        /* a <= b true->1, false->0 */
        case LE_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             // v0 = a, v1 = b
             // check if a <= b, which is same as !(a > b), which is same as !(b < a)
             fprintf(fp,"   slt $t0, $v1, $v0\n");
             nop(fp);
             fprintf(fp,"   xori $v0, $t0, 1\n");
             break;

        /* a >= b true->1, false->0 */
        case GE_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             // v0 = a, v1 = b
             // check if a >= b, which is same as !(a < b)
             fprintf(fp,"   slt $t0, $v0, $v1\n");
             nop(fp);
             fprintf(fp,"   xori $v0, $t0, 1\n");
             break;

        /* a != b true->1, false->0 */
        case NE_AST:
             walk_ast(n->child->brother, fp);
             push("$v0",fp);
             walk_ast(n->child, fp);
             pop("$v1",fp);
             fprintf(fp,"   sub $v0, $v0, $v1\n");
             nop(fp);
             fprintf(fp,"   sltu $v0, $zero, $v0\n");
             break;

        case ARRAY_ACCESS_AST:
            if (n->child->brother->brother != NULL &&
                n->child->brother->brother->brother != NULL) {
                // 2次元配列の代入: arr[i][j] = value;
                char* arr_name = n->child->val.sval;
                int base_offset = symbol_table_get_address(arr_name);
                int cols = symbol_table_get_array_cols(arr_name);

                // 値を保存
                walk_ast(n->child->brother->brother->brother, fp);
                push("$v0", fp);

                // row (i) を計算
                walk_ast(n->child->brother, fp);
                fprintf(fp, "  add $t0, $v0, $zero\n");

                // col (j) を計算
                walk_ast(n->child->brother->brother, fp);
                fprintf(fp, "  add $t1, $v0, $zero\n");

                // index = i * cols + j
                fprintf(fp, "  li $t2, %d\n", cols);
                fprintf(fp, "  mult $t0, $t2\n");
                fprintf(fp, "  mflo $t3\n");
                fprintf(fp, "  add $t3, $t3, $t1\n");

                // バイトオフセットに変換
                fprintf(fp, "  sll $t3, $t3, 2\n");
                fprintf(fp, "  addi $t3, $t3, %d\n", base_offset);
                fprintf(fp, "  add $t3, $fp, $t3\n");

                // 値を格納
                pop("$v0", fp);
                fprintf(fp, "  sw $v0, 0($t3)\n");
            }
            else if (n->child->brother->brother != NULL) {
                char* arr_name = n->child->val.sval;
                int cols = symbol_table_get_array_cols(arr_name);
                if (cols > 0) {
                    // 2次元配列の参照: x = arr[i][j];
                    int base_offset = symbol_table_get_address(arr_name);

                    walk_ast(n->child->brother, fp);
                    fprintf(fp, "  add $t0, $v0, $zero\n");
                    walk_ast(n->child->brother->brother, fp);
                    fprintf(fp, "  add $t1, $v0, $zero\n");

                    fprintf(fp, "  li $t2, %d\n", cols);
                    fprintf(fp, "  mult $t0, $t2\n");
                    fprintf(fp, "  mflo $t3\n");
                    fprintf(fp, "  add $t3, $t3, $t1\n");
                    fprintf(fp, "  sll $t3, $t3, 2\n");
                    fprintf(fp, "  addi $t3, $t3, %d\n", base_offset);
                    fprintf(fp, "  add $t3, $fp, $t3\n");
                    fprintf(fp, "  lw $v0, 0($t3)\n");
                    nop(fp);
                } else {
                    // 1次元配列の代入: arr[i] = value;
                    int base_offset = symbol_table_get_address(arr_name);

                    // 値を保存
                    walk_ast(n->child->brother->brother, fp);
                    push("$v0", fp);

                    // アドレスを計算
                    walk_ast(n->child->brother, fp);
                    fprintf(fp, "  sll $v0, $v0, 2\n");
                    fprintf(fp, "  addi $v0, $v0, %d\n", base_offset);

                    // 値を格納
                    pop("$v1", fp);
                    fprintf(fp, "  add $t0, $fp, $v0\n");
                    fprintf(fp, "  sw $v1, 0($t0)\n");
                }
            }
            else {
                // 1次元配列の参照: x = arr[i];
                char* arr_name = n->child->val.sval;
                int base_offset = symbol_table_get_address(arr_name);

                walk_ast(n->child->brother, fp);
                fprintf(fp, "  sll $v0, $v0, 2\n");
                fprintf(fp, "  addi $v0, $v0, %d\n", base_offset);
                fprintf(fp, "  add $t0, $fp, $v0\n");
                fprintf(fp, "  lw $v0, 0($t0)\n");
                nop(fp);
            }
            break;

        case ARRAY_DECL_STATEMENT_AST:
            break;

        case DECL_STATEMENT_AST:
             break;

        case STATEMENTS_AST:
             walk_ast(n->child,fp);
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
