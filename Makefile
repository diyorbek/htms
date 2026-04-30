all: htms

parser.tab.c parser.tab.h: parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

htms: main.cpp ast.cpp ast.hh html_builder.cpp html_builder.hh parser.tab.c lex.yy.c
	g++ --std=c++20 -o htms main.cpp ast.cpp html_builder.cpp parser.tab.c lex.yy.c

clean:
	rm -f htms

regen-clean:
	rm -f parser.tab.c lex.yy.c parser.tab.h parser.output

.PHONY: all clean regen-clean
