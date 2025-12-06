#!/bin/bash

# =========================================================
# 設定・準備
# =========================================================

# テスト対象の実行ファイル
PROG="./c_program"

# テスト用の一時ファイル名
TEMP_SRC="temp_test_source.txt"
TEMP_LOG="temp_test.log"

# 色の定義
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# カウンター
TOTAL=0
PASS=0
FAIL=0

# コンパイラがあるか確認
if [ ! -f "$PROG" ]; then
    echo -e "${RED}Error: $PROG が見つかりません。make してください。${NC}"
    exit 1
fi

echo "========================================"
echo "   Compiler Test Runner"
echo "========================================"

# クリーンアップ関数（終了時に自動実行）
cleanup() {
    rm -f "$TEMP_SRC" "$TEMP_LOG"
}
trap cleanup EXIT

# ---------------------------------------------------------
# テスト実行関数
# ---------------------------------------------------------
run_test() {
    test_name="$1"
    expected="$2"
    
    TOTAL=$((TOTAL + 1))

    # 実行して、標準出力・標準エラー出力をログに保存
    $PROG < "$TEMP_SRC" > "$TEMP_LOG" 2>&1
    exit_code=$?

    if [ $expected -eq 0 ]; then
        # --- 成功(0)を期待する場合 ---
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}[PASS]${NC} $test_name"
            PASS=$((PASS + 1))
        else
            echo -e "${RED}[FAIL]${NC} $test_name"
            echo -e "       ${RED}Expected success (0), but got exit code $exit_code${NC}"
            echo -e "       ${YELLOW}--- Output Log ---${NC}"
            cat "$TEMP_LOG" | sed 's/^/       /' # インデントして表示
            FAIL=$((FAIL + 1))
        fi
    else
        # --- エラー(1以上)を期待する場合 ---
        if [ $exit_code -ne 0 ]; then
            echo -e "${GREEN}[PASS]${NC} $test_name (Correctly Rejected)"
            PASS=$((PASS + 1))
        else
            echo -e "${RED}[FAIL]${NC} $test_name"
            echo -e "       ${RED}Expected failure (non-zero), but got exit code 0${NC}"
            FAIL=$((FAIL + 1))
        fi
    fi
}

# =========================================================
# テストケース記述エリア
# =========================================================

# test1: 1から10までの和
cat << 'EOF' > "$TEMP_SRC"
define i;
define sum;
sum = 0;
i = 1;
while(i < 11) {
sum = sum + i;
i = i + 1;
}
EOF
run_test "test1: sum" 0
# --------------------------------------
# test2: 5の階乗
cat << 'EOF' > "$TEMP_SRC"
define i;
define fact;
fact = 1;
i = 1;
while(i < 6) {
fact = fact * i;
i = i + 1;
}
EOF
run_test "test2: 5!" 0

# --------------------------------------
cat << 'EOF' > "$TEMP_SRC"
define fizz;
define buzz;
define fizzbuzz;
define others;
define i;
fizz = 0;
buzz = 0;
fizzbuzz = 0;
others = 0;
i = 1;
while(i < 31){
if ((i / 15) * 15 == i){
fizzbuzz = fizzbuzz + 1;
} else {
if ((i / 3) * 3 == i){
fizz = fizz + 1;
} else {
if ((i / 5) * 5 == i){
buzz = buzz + 1;
} else {
others = others + 1;
}
}
}
i = i + 1;
}
EOF
run_test "Simple FizzBuzz" 0
# ------------------------------------------
cat << 'EOF' > "$TEMP_SRC"
define N;
define i;
define j;
define k;
array a[1001];
N = 1000;
i = 1;
while (i <= N) {
a[i] = 1;
i = i + 1;
}
i = 2;
while( i <= N/2) {
j = 2;
while(j <= N/i){
k = i * j;
a[k] = 0;
j = j + 1;
}
i = i + 1;
}
EOF
run_test "test4: eratones" 0

cat << 'EOF' > "$TEMP_SRC"
array matrix1[2][2];
array matrix2[2][2];
array matrix3[2][2];
define i;
define j;
define k;
matrix1[0][0] = 1;
matrix1[0][1] = 2;
matrix1[1][0] = 3;
matrix1[1][1] = 4;
matrix2[0][0] = 5;
matrix2[0][1] = 6;
matrix2[1][0] = 7;
matrix2[1][1] = 8;
for(i=0;i<2;i++){
for(j=0;j<2;j++){
matrix3[i][j] = 0;
}
}
for(i=0;i<2;i++){
for(j=0;j<2;j++){
for(k=0;k<2;k++){
matrix3[i][j] = matrix3[i][j] + matrix1[i][k] * matrix2[k][j];
}
}
}
EOF
run_test "test5: Matrix" 0

cat << 'EOF' > "$TEMP_SRC"
func quicksort(array a[], define l, define r){
define v, i, j, t;
define ii;
if (r > l){
v = a[r]; i = l - 1; j = r;
for(;;){
while(a[++i] < v);
while(a[--j] > v);
if (i >= j) break;
t = a[i]; a[i] = a[j]; a[j] = t;
}
t = a[i]; a[i] = a[r]; a[r] = t;
funccall quicksort(a, l, i-1);
funccall quicksort(a, i+1, r);
}
}
func main(){
array data[10];
data[0] = 10;
data[1] = 4;
data[2] = 2;
data[3] = 7;
data[4] = 3;
data[5] = 5;
data[6] = 9;
data[7] = 10;
data[8] = 1;
data[9] = 8;
funccall quicksort(data, 0, 9);
}

EOF
run_test "quicksort" 0




# =========================================================
# 集計結果
# =========================================================
echo "========================================"
echo -e "Total: $TOTAL, ${GREEN}Passed: $PASS${NC}, ${RED}Failed: $FAIL${NC}"

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}All tests passed! Great job!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
