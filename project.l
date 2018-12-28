digit   [0-9]
letter  [A-Za-z]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum=1;
%}
%%
"#!/bin/sh"	return DIRECTOR;
echo	{yylval.string = strdup(yytext); return ECHORW;}
if	{yylval.string = strdup(yytext); return	IF;}
else {yylval.string = strdup(yytext); return	ELSE;}
then	{yylval.string = strdup(yytext); return	THEN;}
elif {yylval.string = strdup(yytext); return ELIF;}
fi {yylval.string = strdup(yytext); return FINISH;}
while	{yylval.string = strdup(yytext); return WHILE;}
do	{yylval.string = strdup(yytext); return DO;}
done	{yylval.string = strdup(yytext); return DONE;}
\"(\\.|[^"\\])*\"	{yylval.string = malloc(yyleng-1);memcpy(yylval.string,yytext+1,yyleng-2);yylval.string[yyleng-2]='\0';return STRING;}
																												/* yylength is the length of yytext, used to discard quotes from yylval*/
'(\\.|[^'\\])*'		{yylval.string = malloc(yyleng-1);memcpy(yylval.string,yytext+1,yyleng-2);yylval.string[yyleng-2]='\0';return STRING;}
[0-9]+				{yylval.string = strdup(yytext);return INTEGER;}  
{letter}(_|{letter}|{digit})*	{yylval.string = strdup(yytext);return IDENTIFIER;}       	/* Added _ since identifier can have that inside them as well */
=	return EQUALOP;
"$"	return IDENTIFIEROP;
";"	return SEMICOLON;
"."	return CONCATENATESTR;
"(" return PARANTOP;
")" return PARANTCLO;
"[ "	return BRAOP;
" ]"	return BRACLO;
"-" return MINUSOP;
"/"	return DIVOP;
"+" return PLUSOP;
"-eq" {yylval.string = strdup(yytext); return EQ;}
"-lt" {yylval.string = strdup(yytext); return LT;}
"-le" {yylval.string = strdup(yytext); return LE;}
"-gt" {yylval.string = strdup(yytext); return GT;}
"-ge" {yylval.string = strdup(yytext); return GE;}
#.*	{yylval.string = strdup(yytext); return COMMENT;}
"*"	return MULTIPLYOP;
\n	{linenum++;}
[ \t]+ 
%%
