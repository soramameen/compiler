#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

// ここにシンボルテーブル関連の関数の宣言を追加していく
typedef struct {
    char name[32];
    int address;
} Symbol;

void symbol_table_init();

void symbol_table_add(char* name);

int symbol_table_get_address(char* name);

int symbol_table_get_total_size();

#endif
