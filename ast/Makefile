#====================================================
# 1. OSの自動検出
#====================================================
UNAME_S := $(shell uname -s)

#====================================================
# 2. ファイルと設定
#====================================================
# ここでファイル名を指定します
TARGET     = define_and_assign_num
YACC_FILE  = define_and_assign_num.y
LEX_FILE   = c_program.l
C_SOURCES  = ast.c

CC = gcc

#====================================================
# 3. OSごとの設定切り替え
#====================================================
ifeq ($(UNAME_S),Darwin)
    #------------------------------------------------
    # [Mac (Darwin)] の場合
    #------------------------------------------------
    # HomebrewのFlexパスを取得
    FLEX_PATH = $(shell brew --prefix flex)

    # インクルードパスとライブラリパスの設定
    CFLAGS = -I$(FLEX_PATH)/include
    LIBS   = -L$(FLEX_PATH)/lib -lfl -ly

else
    #------------------------------------------------
    # [Linux] の場合
    #------------------------------------------------
    CFLAGS =
    LIBS   = -lfl -ly
endif

#====================================================
# 4. ビルド・ルール
#====================================================

all: $(TARGET)

$(TARGET): $(YACC_FILE) $(LEX_FILE) $(C_SOURCES)
	# 1. Bison (ヘッダファイルも生成)
	bison -d $(YACC_FILE)

	# 2. Flex
	flex $(LEX_FILE)

	# 3. Compile
	# ast.c (C_SOURCES) も含めてコンパイルします
	$(CC) $(CFLAGS) define_and_assign_num.tab.c lex.yy.c $(C_SOURCES) -o $@ $(LIBS)

#====================================================
# 5. クリーンアップ
#====================================================
clean:
	rm -f $(TARGET) define_and_assign_num.tab.c define_and_assign_num.tab.h lex.yy.c

.PHONY: all clean
