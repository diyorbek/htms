%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
%}

%%

"{"     { return LBRACE; }
"}"     { return RBRACE; }
":"     { return COLON; }
";"     { return SEMICOLON; }
-?[0-9]+[a-z]{0,5} {  return UNIT; }
\'[^\']*\' {  return SINGLE_QUOTE_STRING; }
\"[^\"]*\" {  return DOUBLE_QUOTE_STRING; }
[\.#]?[-a-zA-Z0-9_]+ {  return IDENTIFIER; }
[ \t\n]  { /* Ignore whitespace and newlines */ }
.       { fprintf(stderr, "Error: Unknown character %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
