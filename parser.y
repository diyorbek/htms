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
using std::vector;

Sheet* sheet;
%}


%union {
    char* strval;
    
    Property* property;
    std::vector<Property*>* property_list;
    
    Rule* rule;
    std::vector<Rule*>* rule_list;

    Sheet* sheet;
}

%token <strval> IDENTIFIER;
%token <strval> COLON;
%token <strval> SEMICOLON;
%token <strval> LBRACE;
%token <strval> RBRACE;
%token <strval> SINGLE_QUOTE_STRING;
%token <strval> DOUBLE_QUOTE_STRING;
%token <strval> UNIT;

%type <strval> value;
%type <property> property;
%type <property_list> property_list;
%type <rule> rule;
%type <rule_list> rule_list;
%type <sheet> markup_sheet;
%%

markup_sheet: { $$ = new Sheet{}; } | rule_list {
    $$ = new Sheet{$1};
    sheet = $$;
  };

rule_list: rule {
    $$=new vector<Rule*>();
    $$->push_back($1);
  } | rule_list rule {
    $$->push_back($2);
  };

rule: IDENTIFIER LBRACE RBRACE {
    $$ = new Rule{$1};
  } | IDENTIFIER LBRACE property_list RBRACE {
    $$ = new Rule{$1, $3};
  } | IDENTIFIER LBRACE property_list rule_list RBRACE {
    $$ = new Rule{$1, $3, new Sheet{$4}};
  } | IDENTIFIER LBRACE rule_list RBRACE {
    $$ = new Rule{$1, nullptr, new Sheet{$3}};
  };

property_list: property {
    $$=new vector<Property*>();
    $$->push_back($1);
  } | property_list property {
    $$->push_back($2);
  };

property: IDENTIFIER COLON value SEMICOLON {
    $$ = new Property{$1, $3};
  };

value: SINGLE_QUOTE_STRING | DOUBLE_QUOTE_STRING | UNIT | IDENTIFIER 
  | value UNIT {
    std::strcpy($$ , (std::string($$) + " " + $2).c_str());
  } | value IDENTIFIER {
    std::strcpy($$ , (std::string($$) + " " + $2).c_str());
  };

%%

void print_sheet(const Sheet* sheet) {
  if (sheet == nullptr)
    return;

  for (auto& rule : *sheet->rules) {
    cout << rule->selector << endl;

    if (rule->properties) {
      for (auto& property : *rule->properties) {
        cout << property->name << ":" << property->value << endl;
      }
    }
    
    print_sheet(rule->children);
  }
}

int main() {
    yyparse();
    print_sheet(sheet);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
