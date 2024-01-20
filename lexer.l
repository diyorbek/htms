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
-?[0-9]+ {  return UNIT; }
\"[^\"]*\" {  return STRING; }
[-a-zA-Z0-9_]+ {  return IDENTIFIER; }
[ \t\n]  { /* Ignore whitespace and newlines */ }
.       { fprintf(stderr, "Error: Unknown character %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
