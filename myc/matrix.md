# 2次元配列を使えるようになりたい。

## 2次元配列とは
```
[[1,2],[3,4]]
```
のように要素として配列が使える形である。となると、配列の要素に配列を使えるようにすればいいだけでは？と思う。
配列の中身が同じでないといけない、みたいなやつは、意味解析でやればいいのかな。

### 実装すべきこと

1. 宣言

```
  array matrix1[2][2];
```

2. 代入文

```
  matrix1[0][0] = 1;
```

3. 項として扱えるようにする

## 実装する

1. 宣言

2次元までならこれでもいいのでは？2個も範囲内にする。
```
decl_statement /* 宣言文 */
    : DEFINE IDENT SEMIC {printf("OK! ident=%s\n",$2);}
    | ARRAY IDENT L_BRACKET NUMBER R_BRACKET SEMIC {printf("OK! array ident=%s size=%d\n",$2,$4);}
    | ARRAY IDENT L_BRACKET NUMBER R_BRACKET L_BRACKET NUMBER R_BRACKET SEMIC {printf("OK! array ident=%s size=%d\n",$2,$4);}
;
```

2. 代入文

宣言と同じように2次元までならいけるようにした。

```
assignment_stmt /* 代入文 */
    : IDENT ASSIGN expression SEMIC
    | IDENT L_BRACKET expression R_BRACKET ASSIGN expression SEMIC
    | IDENT L_BRACKET expression R_BRACKET L_BRACKET expression R_BRACKET ASSIGN expression SEMIC
;
```

3. 項として使えるようにする

```
term /* 項 */
    : term mul_op factor
    | factor
;
```
項の定義からして、factorに２次元配列が入ればいいことがわかるので、追加する

```
factor /* 因子 */
    : var 
    | L_PAREN expression R_PAREN
;
```
と思ったがexpressionで使えれば良さそう
```
expression /* 算術式 */
    : expression add_op term
    | term
;
```
と思ったがtermに戻ってきた。
ここで気づく。varで使えるべきだ。

```
var /* 変数 */
    : IDENT
    | NUMBER
    | IDENT L_BRACKET expression R_BRACKET
    | IDENT L_BRACKET expression R_BRACKET L_BRACKET expression R_BRACKET
;
```
ここでテスト通れば完成

