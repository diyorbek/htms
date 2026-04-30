GEN := gen

all: htms

$(GEN)/parser.tab.c $(GEN)/parser.tab.h: parser.y
	mkdir -p $(GEN)
	bison -t -v -d -o $(GEN)/parser.tab.c parser.y

$(GEN)/lex.yy.c: lexer.l $(GEN)/parser.tab.h
	mkdir -p $(GEN)
	flex -o $(GEN)/lex.yy.c lexer.l

htms: main.cpp ast.cpp ast.hh html_builder.cpp html_builder.hh $(GEN)/parser.tab.c $(GEN)/lex.yy.c
	g++ --std=c++20 -I. -o htms main.cpp ast.cpp html_builder.cpp $(GEN)/parser.tab.c $(GEN)/lex.yy.c

clean:
	rm -f htms

regen-clean:
	rm -rf $(GEN)

.PHONY: all clean regen-clean
