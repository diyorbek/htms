all: parser

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser: clean lex.yy.c parser.tab.c parser.tab.h
	g++ --std=c++20 -o htms main.cpp ast.cpp html_builder.cpp parser.tab.c lex.yy.c

clean:
	rm -f htms parser parser.tab.c lex.yy.c parser.tab.h parser.output