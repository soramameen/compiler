#include "symbol_table.h"
#include <string.h>
#include <stdio.h>
#define MAX_SYMBOLS 100

static Symbol table[MAX_SYMBOLS];
static int symbol_count = 0;
static int current_address_offset = 0;

void symbol_table_init(){
    symbol_count=0;
    current_address_offset =0;
}

void symbol_table_add(char* name){
    if (symbol_count >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: MAX_SYMBOLSを超えています\n");
        return;
    }
    current_address_offset -=4;

    strcpy(table[symbol_count].name, name);
    table[symbol_count].address = current_address_offset;

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

