%{
    char* word;
%}
%%
is|am|are|were|was {
    printf("%s: is a verb.\n", yytext);
  } 
[a-zA-Z]+ {
    printf("%s: not a verb.\n", yytext);
  }
[ \t\n]+    ; // Ignore whitespace
<<EOF>> return 0;
%%
int main(void) {
    yylex();
    return 0;
}
