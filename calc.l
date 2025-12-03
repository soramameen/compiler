%{
#include "calc.tab.h" 
#include <stdlib.h>
extern YYSTYPE yylval;    // ★この行が重要★
%}

%%
[0-9]+  { yylval = atoi(yytext); return NUMBER; }
[ \t]   ; /* 空白とタブは無視 */
\n      { return yytext[0]; } /* 改行で入力終了 */
.       { return yytext[0]; } /* それ以外の文字（+,-,*,/）をそのまま返す */
%%
