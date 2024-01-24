%require "3.8"
%{
#include <iostream>
#include <string>
#include <vector>
#include <stack>
#include "ast.hh"

int yylex(void);
void yyerror(const char *s);

using std::cout;
using std::endl;

Sheet* sheet = new Sheet{};
std::stack<Sheet*> sheet_stack;
%}


%union {
    char * strval;
}

%token <strval> IDENTIFIER;
%token <strval> COLON;
%token <strval> SEMICOLON;
%token <strval> LBRACE;
%token <strval> RBRACE;
%token <strval> SINGLE_QUOTE_STRING;
%token <strval> DOUBLE_QUOTE_STRING;
%token <strval> UNIT;

%type <strval> rule_list rule open property_list property close nested_rule selector empty_rule value;

%%

markup_sheet: | rule_list {std::cout<<"file"<<std::endl;};

rule_list: rule | rule_list rule {cout<<($$)<<"\n";};

rule: selector open property_list close | empty_rule {cout<<($1)<<" - rule \n";};

nested_rule: selector open property_list close | empty_rule {cout<<($1)<<" - nested \n";};

empty_rule: selector open close {cout<<($1)<<" - empty\n";};

property_list: property | property_list property | property_list nested_rule | nested_rule {cout<<($1)<<" - prop list \n";};

property: IDENTIFIER COLON value SEMICOLON {
  cout<<"rulessize"<<sheet_stack.top()->rules.size()<<endl;
  sheet_stack.top()->rules.back()->properties.push_back({$1, $3});
  cout<<"prop -> "<<($1)<<($2)<<$3<<$4<<endl;
  };

value: SINGLE_QUOTE_STRING | DOUBLE_QUOTE_STRING | UNIT | IDENTIFIER | value UNIT | value IDENTIFIER {cout<<($1)<<" - value \n";};

selector: IDENTIFIER {
  Rule* rule = new Rule{$1, std::vector<Property>(), new Sheet{}};
  sheet_stack.top()->rules.push_back(rule);
  cout<<($1)<<" - selector\n";
  };

open: LBRACE {
  if (sheet_stack.size() > 0)
    sheet_stack.push(sheet_stack.top()->rules.back()->children);
};

close: RBRACE {
  cout<<sheet_stack.size()<<endl;
  sheet_stack.pop();
};

%%

int main() {
    sheet_stack.push(sheet);
    yyparse();
    print_sheet(sheet);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
