all: yacc lex
	cc -w lex.yy.c y.tab.c -o project

yacc: project.y
	yacc -d project.y

lex: project.l
	lex project.l


