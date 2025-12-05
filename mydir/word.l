%{
    int word_count = 0;
%}
%%
[a-zA-Z0-9]+ ++word_count;
[ \t\n]+    ;
. ;
%%
int main(void){
    yylex();
    printf("# of words = %d\n", word_count);
    return 0;
  }
