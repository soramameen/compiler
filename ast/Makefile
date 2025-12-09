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
# simple.c が存在しない場合はここを空にするか削除してください
C_SOURCES   = ast.c 

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
	rm -f $(TARGET) *.tab.c *.tab.h lex.yy.c

#====================================================
# 6. テスト実行
#====================================================
test: $(TARGET)
	@echo "----------------------------------------"
	@echo "Testing with test.txt..."
	@echo "----------------------------------------"
	./$(TARGET) < test.txt

.PHONY: all clean test
