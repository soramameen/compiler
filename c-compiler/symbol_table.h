#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef enum {
    TYPE_SCALAR,  // 通常の変数
    TYPE_ARRAY    // 配列
} SymbolType;

typedef struct {
    char name[32];
    int address;      // ベースアドレス（$fpからのオフセット）
    int size;         // 総要素数
    SymbolType type;  // TYPE_SCALAR または TYPE_ARRAY
    int rows;         // 行数（2次元配列の場合）、それ以外は0
    int cols;         // 列数（2次元配列の場合）、それ以外は0
} Symbol;

void symbol_table_init();

void symbol_table_add(char* name);

void symbol_table_add_array(char* name, int size);

void symbol_table_add_array_2d(char* name, int rows, int cols);

int symbol_table_is_array(char* name);

int symbol_table_get_address(char* name);

int symbol_table_get_total_size();

int symbol_table_get_array_rows(char* name);

int symbol_table_get_array_cols(char* name);

#endif
