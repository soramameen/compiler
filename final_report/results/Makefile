#====================================================
# 1. OSの自動検出
#====================================================
UNAME_S := $(shell uname -s)

#====================================================
# 2. ファイルと設定
#====================================================
TARGET      = program
SRC_DIR     = src
TEST_DIR    = tests
UNIT_TEST_DIR = $(TEST_DIR)/unit
CASE_TEST_DIR = $(TEST_DIR)/cases
OUTPUT_DIR  = output

YACC_FILE   = $(SRC_DIR)/program.y
LEX_FILE    = $(SRC_DIR)/c_program.l
C_SOURCES   = $(SRC_DIR)/main.c $(SRC_DIR)/ast.c $(SRC_DIR)/codegen.c $(SRC_DIR)/symbol_table.c

# 生成される中間ファイル
TAB_C       = $(SRC_DIR)/program.tab.c
TAB_H       = $(SRC_DIR)/program.tab.h
LEX_C       = $(SRC_DIR)/lex.yy.c

CC = gcc

#====================================================
# 3. OSごとの設定切り替え
#====================================================
ifeq ($(UNAME_S),Darwin)
    # brewで入れた flex と bison のパスを取得
    FLEX_PATH  = $(shell brew --prefix flex)
    BISON_PATH = $(shell brew --prefix bison)

    # インクルードパスとライブラリパスの設定
    CFLAGS = -I$(FLEX_PATH)/include -I$(BISON_PATH)/include -I$(SRC_DIR)
    LIBS   = -L$(FLEX_PATH)/lib -L$(BISON_PATH)/lib -lfl

    # コマンドをフルパスで指定する変数を定義
    YACC   = $(BISON_PATH)/bin/bison
    LEX    = $(FLEX_PATH)/bin/flex
else
    # Linuxなどの場合
    CFLAGS = -I$(SRC_DIR)
    LIBS   = -lfl -ly
    YACC   = bison
    LEX    = flex
endif

#====================================================
# 4. ビルド・ルール
#====================================================

all: $(TARGET)

$(TARGET): $(YACC_FILE) $(LEX_FILE) $(C_SOURCES)
	$(YACC) -d $(YACC_FILE) -o $(TAB_C)
	$(LEX) -o $(LEX_C) $(LEX_FILE)
	$(CC) $(CFLAGS) $(TAB_C) $(LEX_C) $(C_SOURCES) -o $@ $(LIBS)

#====================================================
# 5. クリーンアップ
#====================================================
clean:
	rm -f $(TARGET) $(SRC_DIR)/*.tab.c $(SRC_DIR)/*.tab.h $(SRC_DIR)/lex.yy.c test_codegen test_sum $(OUTPUT_DIR)/*.s

#====================================================
# 6. テスト実行
#====================================================
test_codegen: $(UNIT_TEST_DIR)/test_codegen.c $(SRC_DIR)/codegen.c $(SRC_DIR)/ast.c $(SRC_DIR)/symbol_table.c
	$(CC) $(CFLAGS) -o $@ $^

test_sum: $(UNIT_TEST_DIR)/test_sum.c $(SRC_DIR)/codegen.c $(SRC_DIR)/ast.c $(SRC_DIR)/symbol_table.c
	$(CC) $(CFLAGS) -o $@ $^

# 簡易テスト実行（既存のtest.txtがないため、sum.cを使用する例に変更）
test: $(TARGET)
	@echo "----------------------------------------"
	@echo "Testing with $(CASE_TEST_DIR)/sum.c..."
	@echo "----------------------------------------"
	./$(TARGET) < $(CASE_TEST_DIR)/sum.c > $(OUTPUT_DIR)/sum.s
	@echo "Generated $(OUTPUT_DIR)/sum.s"

# 各種ランナールール（パスを修正）
run_sum: test_sum
	./test_sum > $(OUTPUT_DIR)/sum.s && maps -e $(OUTPUT_DIR)/sum.s

run_kaizyo: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/kaizyo.c > $(OUTPUT_DIR)/kaizyo.s && maps -e $(OUTPUT_DIR)/kaizyo.s

run_fizzbuzz: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/fizzbuzz.c > $(OUTPUT_DIR)/fizzbuzz.s && maps -e $(OUTPUT_DIR)/fizzbuzz.s

run_era: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/era.c > $(OUTPUT_DIR)/era.s && maps -e $(OUTPUT_DIR)/era.s

run_2d: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/2d.c > $(OUTPUT_DIR)/2d.s && maps -e $(OUTPUT_DIR)/2d.s

run_le: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/test_le.c > $(OUTPUT_DIR)/test_le.s && maps -e $(OUTPUT_DIR)/test_le.s

run_ge: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/test_ge.c > $(OUTPUT_DIR)/test_ge.s && maps -e $(OUTPUT_DIR)/test_ge.s

run_both: $(TARGET)
	./$(TARGET) < $(CASE_TEST_DIR)/test_both.c > $(OUTPUT_DIR)/test_both.s && maps -e $(OUTPUT_DIR)/test_both.s

check_fizzbuzz: $(TARGET)
	@echo "Checking if $(CASE_TEST_DIR)/fizzbuzz.c can be parsed..."
	./$(TARGET) < $(CASE_TEST_DIR)/fizzbuzz.c > /dev/null
	@echo "Parse Success!"

check_if_program: $(TARGET)
	@echo "Checking if $(CASE_TEST_DIR)/if_program.c can be parsed..."
	./$(TARGET) < $(CASE_TEST_DIR)/if_program.c > /dev/null
	@echo "Parse Success!"

.PHONY: all clean test test_codegen test_sum run_sum run_kaizyo run_le run_ge run_both check_fizzbuzz check_if_program
