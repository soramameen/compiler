%{
	int num_words = 0;
%}

%%

"quit" {return 0;}
[^ \t\n]+ {printf("Word: %s\n",yytext);}
[ \t\n]  

%%

int main(void){
	yylex();
	return 0;
}
