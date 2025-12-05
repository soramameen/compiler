%{
	#include <stdio.h>
	#include "define_all.tab.h"
	extern int yylex();
	extern int yyerror();
%}

%union{
	int num;
	char* str;	
}

%token ASSIGN SEMIC DEFINE  <num>NUMBER <str>IDENT

%%

statement
     : IDENT ASSIGN NUMBER SEMIC {printf("OK! ident=%s, num=%d\n",$1,$3);}
     | DEFINE IDENT SEMIC {printf("OK!\n");}
;

%%

int main(void) {
	if(yyparse()){
	  fprintf(stderr, "Error!\n");
	  return 1;
	}
	return 0;
}
