#include <iostream>

#include "ast.hh"
#include "html_builder.hh"

int yyparse(void);
void yyerror(const char* s);
Sheet* sheet;

int main() {
  yyparse();
  build_html(std::cout, sheet, 2);
  return 0;
}