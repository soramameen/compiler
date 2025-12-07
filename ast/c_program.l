%{
#include "define_and_assign_num.tab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%%
define  {return DEFINE;}

"=="    {return EQ;}
"!="    {return NE;}
"<="    {return LE;}
">="    {return GE;}
"<"     {return LT;}
">"     {return GT;}

"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return MUL;}
"/"     {return DIV;}

"="     {return ASSIGN;}
";"     {return SEMIC;}

"("     {return L_PAREN;}
")"     {return R_PAREN;}
"["     {return L_BRACKET;}
"]"     {return R_BRACKET;}
"{"     {return L_BRACE;}
"}"     {return R_BRACE;}

array   {return ARRAY;}
while   {return WHILE;}
for     {return FOR;}
if      {return IF;}
else    {return ELSE;}
[a-zA-Z][a-zA-Z0-9]* {
  yylval.str = (char*)malloc(sizeof(char) * yyleng);
  strncpy(yylval.str, yytext, yyleng);
  return IDENT;
}
[0-9]+	{yylval.num = atoi(yytext); return NUMBER;}
[ \t\n]+
.	{return yytext[0];}

%%
