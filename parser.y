%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
char* yytext;
%}

%token IDENTIFIER COLON SEMICOLON LBRACE RBRACE SINGLE_QUOTE_STRING DOUBLE_QUOTE_STRING UNIT

%%

scss_file: | rule_list;

rule_list: rule | rule_list rule;

rule: selector LBRACE property_list RBRACE | empty_rule;

nested_rule: selector LBRACE property_list RBRACE | empty_rule;

empty_rule: selector LBRACE RBRACE;

property_list: property | property_list property | property_list nested_rule | nested_rule;

property: IDENTIFIER COLON value SEMICOLON;

value: SINGLE_QUOTE_STRING | DOUBLE_QUOTE_STRING | UNIT | IDENTIFIER | value UNIT | value IDENTIFIER;

selector: IDENTIFIER;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
