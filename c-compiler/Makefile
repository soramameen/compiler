#====================================================
# 1. OSの自動検出
#====================================================
UNAME_S := $(shell uname -s)

#====================================================
# 2. ファイルと設定
#====================================================
TARGET      = program
YACC_FILE   = program.y
LEX_FILE    = c_program.l
C_SOURCES   = main.c ast.c codegen.c symbol_table.c

CC = gcc

#====================================================
# 3. OSごとの設定切り替え (ここを修正！)
#====================================================
ifeq ($(UNAME_S),Darwin)
    # brewで入れた flex と bison のパスを取得
    FLEX_PATH  = $(shell brew --prefix flex)
    BISON_PATH = $(shell brew --prefix bison)

    # インクルードパスとライブラリパスの設定
    CFLAGS = -I$(FLEX_PATH)/include -I$(BISON_PATH)/include
    LIBS   = -L$(FLEX_PATH)/lib -L$(BISON_PATH)/lib -lfl

    # コマンドをフルパスで指定する変数を定義
    YACC   = $(BISON_PATH)/bin/bison
    LEX    = $(FLEX_PATH)/bin/flex
else
    # Linuxなどの場合
    CFLAGS =
    LIBS   = -lfl -ly
    YACC   = bison
    LEX    = flex
endif

#====================================================
# 4. ビルド・ルール
#====================================================

all: $(TARGET)

$(TARGET): $(YACC_FILE) $(LEX_FILE) $(C_SOURCES)
    # 定義した変数 $(YACC) を使う (ここが重要！)
	$(YACC) -d $(YACC_FILE)
	$(LEX) $(LEX_FILE)
	$(CC) $(CFLAGS) program.tab.c lex.yy.c $(C_SOURCES) -o $@ $(LIBS)

#====================================================
# 5. クリーンアップ
#====================================================
clean:
	rm -f $(TARGET) *.tab.c *.tab.h lex.yy.c test_codegen test_sum

#====================================================
# 6. テスト実行
#====================================================
test_codegen: test_codegen.c codegen.c ast.c symbol_table.c
	$(CC) -o $@ $^

test_sum: test_sum.c codegen.c ast.c symbol_table.c
	$(CC) -o $@ $^

test: $(TARGET)
	@echo "----------------------------------------"
	@echo "Testing with test.txt..."
	@echo "----------------------------------------"
	./$(TARGET) < test.txt

run_sum: test_sum
	./test_sum > sum.s && maps -e sum.s

run_kaizyo: program
	./program < tests/kaizyo.c > kaizyo.s && maps -e kaizyo.s

run_fizzbuzz: program
	./program < tests/fizzbuzz.c > fizzbuzz.s && maps -e fizzbuzz.s

.PHONY: all clean test test_codegen test_sum run_sum run_kaizyo check_fizzbuzz

check_fizzbuzz: $(TARGET)
	@echo "Checking if tests/fizzbuzz.c can be parsed..."
	./$(TARGET) < tests/fizzbuzz.c
	@echo "Parse Success!"

check_if_program: $(TARGET)
	@echo "Checking if tests/if_program.c can be parsed..."
	./$(TARGET) < tests/if_program.c
	@echo "Parse Success!"
