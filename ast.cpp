#include "ast.hh"

#include <algorithm>
#include <iostream>

void print_sheet(const Sheet* sheet, int indent) {
  using namespace std;

  if (sheet == nullptr)
    return;

  for (auto& rule : *sheet->rules) {
    fill_n(ostream_iterator<char>(cout), indent, '#');
    cout << rule->selector << endl;

    if (rule->properties) {
      for (auto& property : *rule->properties) {
        fill_n(ostream_iterator<char>(cout), indent + 2, '-');
        cout << property->name << ": " << property->value << endl;
      }
    }

    print_sheet(rule->children, indent + 2);
  }
}