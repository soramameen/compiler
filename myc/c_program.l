%{
    #include "c_program.tab.h"
%}

%%
define  {return DEFINE;}

// 比較演算子
"=="    {return EQ;}
"!="    {return NE;}
"<="    {return LE;}
">="    {return GE;}
"<"     {return LT;}
">"     {return GT;}

// 算術演算子
"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return MUL;}
"/"     {return DIV;}

// 代入・区切り
"="     {return ASSIGN;}
";"     {return SEMIC;}

// 括弧
"("     {return L_PAREN;}
")"     {return R_PAREN;}
"["     {return L_BRACKET;}
"]"     {return R_BRACKET;}
"{"     {return L_BRACE;}
"}"     {return R_BRACE;}

// キーワード
array   {return ARRAY;}
while   {return WHILE;}
if      {return IF;}
else    {return ELSE;}
[a-zA-Z][a-zA-Z0-9]* {
	yylval.str = (char*)malloc(sizeof(char) * yyleng);
	strncpy(yylval.str, yytext, yyleng);
	return IDENT;
}
[0-9]+	{yylval.num = atoi(yytext); return NUMBER;}
[ \t]+
\n	{return 0;}
.	{return yytext[0];}
