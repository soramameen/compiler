%{
	int num_words = 0;
	int num_chars = 0;
	int num_lines = 0;
%}

%%

"quit" {return 0;}
[\n] {num_lines++;}
[^ \t\n]+ {printf("Word: %s length: %d\n", yytext, yyleng); num_words++; num_chars = num_chars + yyleng;}
[ \t]

%%

int main(void){
	yylex();
	printf("#words=%d length=%d lines=%d \n", num_words, num_chars, num_lines);
	return 0;
}
