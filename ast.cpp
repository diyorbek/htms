#include "ast.hh"

#include <iomanip>
#include <iostream>

void print_sheet(const Sheet* sheet, int indent) {
  using namespace std;

  if (sheet == nullptr)
    return;

  for (auto& rule : *sheet->rules) {
    cout << setfill(' ') << setw(indent + 1);
    cout << rule->selector << endl;

    if (rule->properties) {
      for (auto& property : *rule->properties) {
        cout << setfill(' ') << setw(indent + 3);
        cout << property->name << ": " << property->value << endl;
      }
    }

    print_sheet(rule->children, indent + 2);
  }
}