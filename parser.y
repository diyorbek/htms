%require "3.8"
%{
#include <iostream>
#include <string>
#include <vector>

int yylex(void);
void yyerror(const char *s);

using std::cout;
using std::endl;

struct Property {
  std::string name;
  std::string value;
};

struct Rule {
  std::string selector;
  std::vector<Property> properties;
};

struct Sheet {
  std::vector<Rule> rules;
} sheet;
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

rule: selector open property_list close | empty_rule {cout<<($1)<<"\n";};

nested_rule: selector open property_list close | empty_rule {cout<<($1)<<"\n";};

empty_rule: selector open close {cout<<($1)<<"\n";};

property_list: property | property_list property | property_list nested_rule | nested_rule {cout<<($1)<<"\n";};

property: IDENTIFIER COLON value SEMICOLON {cout<<"prop -> "<<($1)<<($2)<<$3<<$4<<endl;};

value: SINGLE_QUOTE_STRING | DOUBLE_QUOTE_STRING | UNIT | IDENTIFIER | value UNIT | value IDENTIFIER {cout<<($1)<<"\n";};

selector: IDENTIFIER {cout<<($1)<<"\n";};

open: LBRACE {cout<<($1)<<"\n";};

close: RBRACE {cout<<($1)<<"\n";};

%%

int main() {
    yyparse();
    std::cout<<sheet.rules.size()<<std::endl;
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
