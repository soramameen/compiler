#include "symbol_table.h"
#include <string.h>
#include <stdio.h>
#define MAX_SYMBOLS 100

static Symbol table[MAX_SYMBOLS];
static int symbol_count = 0;
static int current_address_offset = 0;

void symbol_table_init(){
    symbol_count=0;
    current_address_offset =-8;
}

void symbol_table_add(char* name){
    if (symbol_count >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: MAX_SYMBOLSを超えています\n");
        return;
    }
    current_address_offset -=4;

    strcpy(table[symbol_count].name, name);
    table[symbol_count].address = current_address_offset;

    // 追加: 新しいフィールドの初期化
    table[symbol_count].type = TYPE_SCALAR;
    table[symbol_count].size = 1;
    table[symbol_count].rows = 0;
    table[symbol_count].cols = 0;

    symbol_count++;
}

int symbol_table_get_address(char* name) {
    for (int i =0; i<symbol_count; i++){
        if(strcmp(table[i].name,name) ==0){
            return table[i].address;
        }
    }
    return 0;
}

int symbol_table_get_total_size(){
    return -current_address_offset;
}

void symbol_table_add_array(char* name, int size){
    if (symbol_count >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: MAX_SYMBOLSを超えています\n");
        return;
    }
    current_address_offset -= size * 4;

    strcpy(table[symbol_count].name, name);
    table[symbol_count].address = current_address_offset;
    table[symbol_count].type = TYPE_ARRAY;
    table[symbol_count].size = size;
    table[symbol_count].rows = 0;
    table[symbol_count].cols = 0;

    symbol_count++;
}

void symbol_table_add_array_2d(char* name, int rows, int cols){
    symbol_table_add_array(name, rows * cols);

    // rows と cols を設定（上書き）
    table[symbol_count - 1].rows = rows;
    table[symbol_count - 1].cols = cols;
}

int symbol_table_is_array(char* name){
    for (int i =0; i<symbol_count; i++){
        if(strcmp(table[i].name,name) ==0){
            return table[i].type == TYPE_ARRAY ? 1 : 0;
        }
    }
    return 0;
}

int symbol_table_get_array_rows(char* name){
    for (int i =0; i<symbol_count; i++){
        if(strcmp(table[i].name,name) ==0){
            return table[i].rows;
        }
    }
    return 0;
}

int symbol_table_get_array_cols(char* name){
    for (int i =0; i<symbol_count; i++){
        if(strcmp(table[i].name,name) ==0){
            return table[i].cols;
        }
    }
    return 0;
}

