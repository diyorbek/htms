#include <iostream>
#include <stack>
#include <string>
#include <vector>

struct Sheet;

struct Property {
  std::string name;
  std::string value;
};

struct Rule {
  std::string selector;
  std::vector<Property> properties;
  Sheet* children;
};

struct Sheet {
  std::vector<Rule*> rules;
};

void print_sheet(const Sheet* sheet) {
  // Sheet* sheet = new Sheet{};
  // std::stack<Sheet*> sheet_stack;
  // sheet_stack.top()->rules.back()->properties.push_back({"", ""});

  using namespace std;
  for (const Rule* rule : sheet->rules) {
    cout << rule->selector << endl;
    for (const Property& property : rule->properties) {
      cout << rule->selector << endl;
    }

    if (rule->children == nullptr)
      continue;

    print_sheet(rule->children);
  }
}