#!/bin/bash

# コンパイラの実行ファイル名
PROG="./c_program"

# 色の定義
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# コンパイラがあるか確認
if [ ! -f "$PROG" ]; then
    echo "Error: $PROG が見つかりません。make してください。"
    exit 1
fi

echo "========================================"
echo "   Compiler Test Runner (Strict Mode)"
echo "========================================"

# ---------------------------------------------------------
# テスト実行関数
# ---------------------------------------------------------
run_test() {
    test_name=$1
    input_file=$2
    expected=$3

    $PROG < "$input_file" > /dev/null 2>&1
    exit_code=$?

    if [ $expected -eq 0 ]; then
        # 成功を期待
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}[PASS]${NC} $test_name"
        else
            echo -e "${RED}[FAIL]${NC} $test_name (Unexpected Error)"
        fi
    else
        # エラーを期待
        if [ $exit_code -ne 0 ]; then
            echo -e "${GREEN}[PASS]${NC} $test_name (Correctly Rejected)"
        else
            echo -e "${RED}[FAIL]${NC} $test_name (Unexpected Success)"
        fi
    fi
}

# =========================================================
# 1. 正常系テスト (成功すべきパターン)
# =========================================================

# --- Case 1: 基本的な演算 ---
# 修正: 定義と代入を分離
cat << 'EOF' > test_math.txt
define a;
define b;
define c;
a = 10;
b = 20;
c = a + b * 2;
c = (a + b) * 2;
EOF
run_test "Basic Math & Priority" "test_math.txt" 0

# --- Case 2: 制御構文 (If/While) ---
# 修正: 定義は全て最初に行う
cat << 'EOF' > test_flow.txt
define x;
define y;
x = 0;
y = 10;
while (x < y) {
    if (x == 5) {
        y = y - 1;
    } else {
        x = x + 1;
    }
}
EOF
run_test "Control Flow (If/While)" "test_flow.txt" 0

# --- Case 3: 配列操作 ---
# 修正: array定義も先頭、代入は後
cat << 'EOF' > test_array.txt
array arr[5];
define i;
i = 0;
arr[0] = 10;
arr[1] = 20;
while (i < 2) {
    arr[i] = arr[i] + 5;
    i = i + 1;
}
EOF
run_test "Array Operations" "test_array.txt" 0

# --- Case 4: ネスト (入れ子) ---
cat << 'EOF' > test_nested.txt
define n;
n = 0;
if (n == 0) {
    while (n < 5) {
        if (n < 2) {
            n = n + 2;
        } else {
            n = n + 1;
        }
    }
}
EOF
run_test "Nested Structures" "test_nested.txt" 0

# =========================================================
# 2. 異常系テスト (エラーになるべきパターン)
# =========================================================

# --- Case 5: 定義と代入の同時記述 ---
# 今回の仕様ではこれがエラーになるはず
cat << 'EOF' > fail_init.txt
define a = 10;
EOF
run_test "Fail: Simultaneous Define & Assign" "fail_init.txt" 1

# --- Case 6: 順序違R (文の後に宣言) ---
cat << 'EOF' > fail_order.txt
define a;
a = 10;
define b;
b = 20;
EOF
run_test "Fail: Declaration after Statement" "fail_order.txt" 1

# --- Case 7: セミコロン忘れ ---
cat << 'EOF' > fail_semi.txt
define a;
a = 10
EOF
run_test "Fail: Missing Semicolon" "fail_semi.txt" 1

echo "========================================"
echo "Tests Completed."
rm test_math.txt test_flow.txt test_array.txt test_nested.txt fail_init.txt fail_order.txt fail_semi.txt
