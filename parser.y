%require "3.8"
%{
#include <iostream>
#include <string>
#include <vector>
#include <stack>

#include "ast.hh"
#include "html_builder.hh"

extern int yylex(void);
extern void yyerror(const char *s);

extern Sheet* sheet;
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
    $$ = new std::vector<Rule*>();
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
    $$ = new std::vector<Property*>();
    $$->push_back($1);
  } | property_list property {
    $$->push_back($2);
  };

property: IDENTIFIER COLON value SEMICOLON {
    $$ = new Property{$1, $3};
  };

value: SINGLE_QUOTE_STRING | DOUBLE_QUOTE_STRING | UNIT | IDENTIFIER
  | value UNIT {
    $$ = strdup((std::string($1) + " " + $2).c_str());
  } | value IDENTIFIER {
    $$ = strdup((std::string($1) + " " + $2).c_str());
  };
%%

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}
