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
[a-zA-Z-]+ {  return IDENTIFIER; }
\"[^\"]*\" {  return STRING; }
[ \t\n]  { /* Ignore whitespace and newlines */ }
.       { fprintf(stderr, "Error: Unknown character %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
