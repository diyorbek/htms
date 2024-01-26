%{
#include <stdio.h>
#include <string.h>
#include "ast.hh"
#include "parser.tab.h"
%}

%%

"{"     {yylval.strval = strdup(yytext); return LBRACE; }
"}"     {yylval.strval = strdup(yytext); return RBRACE; }
":"     {yylval.strval = strdup(yytext); return COLON; }
";"     {yylval.strval = strdup(yytext); return SEMICOLON; }
-?[0-9]+[a-z]{0,5} { yylval.strval = strdup(yytext); return UNIT; }
\'[^\']*\' { yylval.strval = strdup(yytext); return SINGLE_QUOTE_STRING; }
\"[^\"]*\" { yylval.strval = strdup(yytext); return DOUBLE_QUOTE_STRING; }
[\.#]?[-a-zA-Z0-9_]+ { yylval.strval = strdup(yytext); return IDENTIFIER; }
[ \t\n]  { /* Ignore whitespace and newlines */ }
.       { fprintf(stderr, "Error: Unknown character %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
