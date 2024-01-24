all: parser

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser: clean lex.yy.c parser.tab.c parser.tab.h
	g++ --std=c++20 -o parser parser.tab.c lex.yy.c

clean:
	rm -f parser parser.tab.c lex.yy.c parser.tab.h parser.output