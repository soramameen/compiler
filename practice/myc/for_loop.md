# forループを作りたい。

## 目標となるプログラム

```
for(k=0;k<2;k=k+1){
matrix3[i][j] = matrix3[i][j] + matrix1[i][k] * matrix2[k][j];
}
```

これを通せば良い。

## forループについて理解する

カーニハンリッチーによるとforループは以下のように定義したものらしい。

```
for (exp1; exp2; exp3) {
    文
}
```
最後にはセミコロンがつかないことに注意する。
これを踏まえて実装してみる

## 実装

いざ実装しようとすると難しい。全部expなのでexpressionっぽいが、本当にそれでいいのか。
よくなさそうということで踏みとどまって考える。
c言語のexp1は初期化文である。`i=0` のようなものなので代入文を入れたい。
exp2は、条件式である。`i<10` こんなのを入れたい
exp3は、increment文みたいなものである。 `i+=1` みたいなのを入れたい・

ということで以下のような並びになりそう。

```
FOR ( assignment_stmt ; condition ; assignment_stmt){
    statements
    }
```
これでやってみよう

```
loop_stmt /* ループ文 */
    : WHILE L_PAREN condition R_PAREN L_BRACE statements R_BRACE
    | FOR L_PAREN assignment_stmt SEMIC condition SEMIC assignment_stmt R_PAREN L_BRACE statements R_BRACE
    
;
```

こんな感じで定義してみたのでテストする。
うまくいかなった。原因は、assignment_stmtにSEMICが含まれていたからだった。
次は `k=k+1)`のところで詰まった。`k=k+1`をassignment_stmtとしていたのでSEMICが必要になってしまた。なので、3つめをassignment_stmtじゃないものにすべきだ。一つめもあやしいが。。。

3つめは更新式である。最初の一回だけの更新式だと思えば1つ目も更新式だが。。。

`i=i+1`のような簡易的な式のみ許容するようにする。簡易的とはいえど配列を許容していないだけだが。exp1もこれが正しい気もしなくもない。

```
loop_stmt /* ループ文 */
    : WHILE L_PAREN condition R_PAREN L_BRACE statements R_BRACE
    | FOR L_PAREN assignment_stmt condition SEMIC IDENT ASSIGN expression R_PAREN L_BRACE statements R_BRACE
;
```


