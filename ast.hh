#pragma once

#include <string>
#include <vector>

struct Sheet;

struct Property {
  std::string name;
  std::string value;
};

struct Rule {
  std::string selector;
  std::vector<Property*>* properties;
  Sheet* children;
};

struct Sheet {
  std::vector<Rule*>* rules;
};

void print_sheet(const Sheet* sheet, int indent = 0);
