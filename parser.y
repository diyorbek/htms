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

%type <strval> nested_rule empty_rule;
%type <strval> value;
%type <property> property;
%type <property_list> property_list;
%type <rule> rule;
%type <rule_list> rule_list;
%type <sheet> markup_sheet;
%%

markup_sheet: { $$ = new Sheet{}; } | rule_list {
    $$ = new Sheet{$1};
    // cout<<"sheet = "<<(*$$->rules).size()<<endl;
    sheet = $$;
  };

rule_list: rule {
    $$=new std::vector<Rule*>();
    $$->push_back($1);
    // cout<<"list = "<<$$->size()<<endl;

  } | rule_list rule {
    $$->push_back($2);
    // cout<<"list = "<<$$->size()<<endl;
  };

rule: IDENTIFIER LBRACE property_list RBRACE {
    $$=new Rule{$1, $3};
  } | empty_rule {
    // cout<<($$)<<" - rule empty \n";
  };

nested_rule: IDENTIFIER LBRACE property_list RBRACE | empty_rule {
    // cout<<($$)<<" - nested \n";
  };

empty_rule: IDENTIFIER LBRACE RBRACE {
    // cout<<($$)<<" - empty\n";
  };

property_list: property {
    $$=new std::vector<Property*>();
    $$->push_back($1);
  } | property_list property {
    $$->push_back($2);
    // cout<<$$->size()<<" - list prop\n";
  } | property_list nested_rule {

  } | nested_rule {
    // cout<<($$)<<" - prop list \n";
  };

property: IDENTIFIER COLON value SEMICOLON {
    $$ = new Property{$1, $3};
    // cout<<"prop -> "<<($1)<<$3<<endl;
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

  using namespace std;

  for (auto& rule : *sheet->rules) {
    cout << rule->selector << endl;
    for (auto& property : *rule->properties) {
      cout << property->name << ":" << property->value << endl;
    }

    if (rule->children == nullptr)
      continue;

    print_sheet(rule->children);
  }
}

int main() {
    yyparse();
    cout<<"=====\n";
    print_sheet(sheet);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
