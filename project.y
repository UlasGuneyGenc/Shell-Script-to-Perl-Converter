%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

extern FILE *yyin;
extern int linenum;
char writeBuffer[100];
%}
%union
{
int number;
char *string;
}
%token <number> INTEGER 
%token <string> STRING  PARANTOP PARANTCLO COMMENT PLUSOP MULTIPLYOP MINUSOP DIVOP
%token <string> IDENTIFIER EQ LT LE GT GE IF THEN ELSE ELIF FINISH BRAOP BRACLO WHILE DO DONE
%token ECHORW EQUALOP IDENTIFIEROP SEMICOLON CONCATENATESTR DIRECTOR
%type <string> assign sign expr vars var operator elif_stmt statements statement while_stmt
%type <string> string_list assignment assignment comment_stmt if_else_stmt print_stmt test
%%
statements:
	statements statement{
		strAssignment($2);
		
	}
	|
	{$$="";}
	;

statement:
	DIRECTOR {$$="";}
	|
	assignment {$$=$1;}			
	|
	print_stmt {$$=$1;}
	| 
	comment_stmt {$$=$1;}
	|
	if_else_stmt {$$=$1;}
	|
	while_stmt {$$=$1;}
	;

test:
	assignment test { 
		/*char pr2[1000];
		strcpy(pr2,$2);
		strcat($1,pr2);
		$$=$1;*/
		sprintf($$, "%s%s",strdup($1),strdup($2));
	}			
	|
	print_stmt test {
		
	sprintf($$, "%s%s",strdup($1),strdup($2));
	}
	| 
	comment_stmt test{
		sprintf($$, "%s%s",strdup($1),strdup($2));}
	|
	if_else_stmt test{
		sprintf($$, "%s%s",strdup($1),strdup($2));}
	|
	while_stmt test {sprintf($$, "%s%s",strdup($1),strdup($2));}
	|
	{$$="";}
	
	;
	
while_stmt:
	WHILE BRAOP vars operator vars BRACLO DO test DONE{

		char pr2[1000];
		strcpy(pr2,"while(");
		strcat(pr2,$3);
		strcat(pr2,$4);
		strcat(pr2,$5);
		strcat(pr2,"){\n");
		strcat(pr2,$8);
		strcat(pr2,"\n}");
		strcpy($3,pr2);
		$$=$3;
		//sprintf($$, "while(%s%s%s){\n%s\n}",strdup($3),strdup($4),strdup($5),strdup($8));
	}



	;

if_else_stmt:	
	IF BRAOP vars operator vars BRACLO THEN test  FINISH 
	{

		/*char pr2[100];
		strcpy(pr2,"if");
		strcat(pr2,"(");
		strcat(pr2,$3);
		//strcpy($3,pr2);
		strcat(pr2,$4);
		strcat(pr2,$5);
		strcat(pr2,")");
		strcat(pr2,"{");
		strcat(pr2,$8);
		
		strcat(pr2,"}");
		strcpy($8,pr2);*/

		sprintf($$, "if(%s%s%s){\n\t%s}",strdup($3),strdup($4),strdup($5),strdup($8));
		//$$=$8;
	}
	|
	IF BRAOP vars operator vars BRACLO THEN test elif_stmt FINISH{

		sprintf($$, "if(%s%s%s){\n\t%s\n}%s",strdup($3),strdup($4),strdup($5),strdup($8),strdup($9));	
	}
	|
	IF BRAOP vars operator vars BRACLO THEN test ELSE test FINISH{

		sprintf($$, "if(%s%s%s){\n\t%s\n}\nelse{\n%s\n}",strdup($3),strdup($4),strdup($5),strdup($8),strdup($10));			
	}
	|
	IF BRAOP vars operator vars BRACLO THEN test elif_stmt ELSE test FINISH{
	
		sprintf($$, "if(%s%s%s){\n\t%s\n}\n%s\nelse{\n%s\n}",strdup($3),strdup($4),strdup($5),strdup($8),strdup($9),strdup($11));	
	}
	;

elif_stmt:
	ELIF BRAOP vars operator vars BRACLO THEN test{
	char pr2[100];
	strcpy(pr2,"\telsif");
	strcat(pr2,"(");
	strcat(pr2,$3);
	strcpy($3,pr2);
	strcat($3,$4);
	strcat($3,$5);
	strcat($3,")");
	strcat($3,"{");
	strcat($3,$8);
	strcat($3,"}");
	$$=$3;
		
	}
	|
	ELIF BRAOP vars operator vars BRACLO THEN test elif_stmt{
	sprintf($$, "elsif(%s%s%s){\n\t%s\n}%s",strdup($3),strdup($4),strdup($5),strdup($8),strdup($9));	
		
	}
	; 
operator:
	EQ{
	$$="==";
	}
	|
	LT{
	$$="<";
	}
	|
	LE{
	$$="<=";
	}
	|
	GT{
	$$=">";
	}
	|
	GE{
	$$=">=";
	}
	;

comment_stmt:

	COMMENT {
	
	$$=$1;
	}
	;
assignment:
	IDENTIFIER EQUALOP assign
	{ 	
		char pr[1000];
		strcpy(pr,"$");
		strcat(pr, $1);
		strcat(pr, "=");
		strcat(pr, $3);
		strcat(pr,"\n");
		strcpy($3,pr);
		$$=$3;
		//sprintf($$, "$%s=%s",strdup($1),strdup($3));
		
	}
	|
	IDENTIFIER EQUALOP INTEGER
	{ 	/*char pr2[1000];
		char pr[1000] = "";
		strcpy(pr2,$3);
		strcat(pr2,";");
		strcat(pr,"$");
		strcat(pr, $1);
		strcat(pr, "=");
		strcat(pr, pr2);
		strcpy($3,pr);
		$$=$3;*/
		sprintf($$, "$%s=%s;\n",strdup($1),strdup($3));
	}
	;
	
assign:
	IDENTIFIEROP PARANTOP PARANTOP expr PARANTCLO PARANTCLO
	{
		char pr2[1000] = "";
		strcat(pr2, $4);
		strcat(pr2, ";");
		strcpy($4,pr2);
		$$=$4;
		//sprintf($$, "%s;",strdup($4));*/
	}
	;
expr:
	var sign expr{
		char pr2[100]=""; 
		
		strcat(pr2,$3);
		strcat($1,$2);
		strcat($1,$3);
		$$=$1;
		//sprintf($$, "%s%s%s",strdup($1),strdup($2),strdup($3));
		
	}	
	
	|
	var{ 
		$$=$1;
	}
	|
	PARANTOP expr PARANTCLO expr
	{
		char pr2[100]="";
		strcat(pr2,$2);
		strcpy($2,"(");
		strcat($2,pr2);
		strcat($2,")");
		strcat($2,$4); 
		$$=$2;
		/*char pr2[100]="";
		strcat(pr2,$2);
		strcpy($2,"(");
		strcat($2,pr2);
		strcat($2,$3);
		strcat($2,$4);
		strcat($2,")");
		$$=$2;	*/
		//sprintf($$, "(%s)%s",strdup($2),strdup($4));
	}
	|
	sign expr
	{

	char pr2[100]="";
	strcat(pr2,$1);
	
	strcat(pr2,$2);
	strcpy($2,pr2);
	$$=$2;
	//sprintf($$, "%s%s",strdup($1),strdup($2));	
	
		}
	|
	{$$="";}
	;
vars:
	INTEGER
	{ 
		$$=$1;  
	}
	|
	IDENTIFIEROP IDENTIFIER{
		//char pr2[100]="";
		//strcat(pr2,$2);
		//strcpy($2,"$");
		//strcat($2,pr2);
		//$$=$2;
		sprintf($$, "$%s", strdup($2));
	}
	
	;
var:
	INTEGER
	{ 
		$$=$1;  
	}
	|
	IDENTIFIEROP IDENTIFIER{
		char pr2[100]="";
		strcat(pr2,$2);
		strcpy($2,"$");
		strcat($2,pr2);
		$$=$2;
		//sprintf($$, "$%s", strdup($2));
	}
	|
	IDENTIFIER{char pr[100];
	/*strcpy(pr,"$");
	strcat(pr,$1);
	strcpy($1,pr);		
	$$=$1;*/
	sprintf($$, "$%s", strdup($1));	
	}
	;
sign:
	PLUSOP
    {
	$$="+";
	}
	|
	MINUSOP  {
	$$="-";
	}
	|
	MULTIPLYOP  {
	$$="*";
	}
	|
	DIVOP  {
	$$="/";
	}
	;

print_stmt:
	ECHORW string_list		{
	/*char pr4[100] = "print ";

	strcat(pr4,$2);
	//printf("%s\n",pr4);
	strcpy($2,pr4);
	$$=$2;*/
	sprintf($$, "print %s\n",strdup($2));
									
		}
	;

string_list:
	STRING	{
	/*char pr[100];
	strcpy(pr,$1);
	strcpy($1,"\"");
	strcat($1,pr);
	strcat($1,"\"");
	strcat($1,";");
	$$=$1;*/
	sprintf($$, "\"%s\" .\"\\n\";", strdup($1));
	
	}
	|
	IDENTIFIEROP IDENTIFIER
	{ 
		/*char pr[100];
		strcpy(pr, "$");
		strcat(pr,$2);
		strcat(pr, " . ");
		strcat(pr, "\"");
		strcat(pr, "\\");
		strcat(pr, "n");
		strcat(pr, "\"");
		strcat(pr, ";");
		strcpy($2,pr);
		$$ = $2;*/
		sprintf($$, "$%s . \"\\n\";", strdup($2));
	}
	|assign{$$=$1;}
;
	

%%

void printStmt(char *text){

	FILE *f = fopen("output", "a");
	int len = strlen(text);
	char pr[100] = "print ";

	strcat(pr, text);
	pr[strlen(pr)]='\n';

	fprintf(f,"%s", pr);
	fclose(f);

}

void strAssignment(char *identifier){
	FILE *f = fopen("output", "a");
	char pr[10000] = "";
	strcat(pr, identifier);
	
	
	
	pr[strlen(pr)]='\n';
	
	fprintf(f,"%s", pr);
	fclose(f);
}

void yyerror(char *s){
	fprintf(stderr,"Syntax error at line: %d\n",linenum-1);
	FILE *f = fopen("output", "w");
	fprintf(f, "");
	fclose(f);
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    return 0;
}
