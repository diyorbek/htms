%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
char* yytext;
%}

%token IDENTIFIER COLON SEMICOLON LBRACE RBRACE STRING UNIT

%%

scss_file: rule_list;

rule_list: rule
         | rule_list rule;

rule: selector LBRACE property_list RBRACE;

nested_rule: selector LBRACE property_list RBRACE;

property_list: property | property_list property | property_list nested_rule;

property: IDENTIFIER COLON value SEMICOLON;

value: STRING | UNIT;

selector: IDENTIFIER;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

/* int yylex() {
    int c = getchar();
    if (c == EOF) {
        return 0; // End of file
    } else if (c == '{') {
        return LBRACE;
    } else if (c == '}') {
        return RBRACE;
    } else if (c == ':') {
        return COLON;
    } else if (c == ';') {
        return SEMICOLON;
    } else if (c == '"') {
        int i = 0;
        while ((c = getchar()) != '"' && c != EOF) {
            yytext[i++] = c;
        }
        yytext[i] = '\0';
        return STRING;
    } else if (isalpha(c) || c == '-') {
        int i = 0;
        yytext[i++] = c;
        while (isalnum(c = getchar()) || c == '-') {
            yytext[i++] = c;
        }
        yytext[i] = '\0';
        ungetc(c, stdin);
        return IDENTIFIER;
    } else {
        return c;
    }
} */
