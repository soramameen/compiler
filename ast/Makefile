#====================================================
# 1. OSの自動検出
#====================================================
UNAME_S := $(shell uname -s)

#====================================================
# 2. ファイルと設定
#====================================================
TARGET      = simple
YACC_FILE   = simple.y
LEX_FILE    = c_program.l
C_SOURCES   = ast.c

CC = gcc

#====================================================
# 3. OSごとの設定切り替え
#====================================================
ifeq ($(UNAME_S),Darwin)
    FLEX_PATH = $(shell brew --prefix flex)
    CFLAGS = -I$(FLEX_PATH)/include
    LIBS   = -L$(FLEX_PATH)/lib -lfl -ly
else
    CFLAGS =
    LIBS   = -lfl -ly
endif

#====================================================
# 4. ビルド・ルール
#====================================================

all: $(TARGET)

$(TARGET): $(YACC_FILE) $(LEX_FILE) $(C_SOURCES)
	bison -d $(YACC_FILE)
	flex $(LEX_FILE)
	$(CC) $(CFLAGS) define_and_assign_num.tab.c lex.yy.c $(C_SOURCES) -o $@ $(LIBS)

#====================================================
# 5. クリーンアップ
#====================================================
clean:
	rm -f $(TARGET) define_and_assign_num.tab.c define_and_assign_num.tab.h lex.yy.c

#====================================================
# 6. テスト実行 (ここを追加！)
#====================================================
test: $(TARGET)
	@echo "----------------------------------------"
	@echo "Testing with test.txt..."
	@echo "----------------------------------------"
	./$(TARGET) < test.txt

# .PHONY に test を追加するのを忘れずに
.PHONY: all clean test
