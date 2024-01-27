#include "html_builder.hh"
#include <format>
#include <iomanip>
#include <string>

void indent(std::ostream& out, u_int indentation) {
  using namespace std;
  fill_n(ostream_iterator<char>(out), indentation, ' ');
}

void __build_html(std::ostream& out,
                  const Sheet* sheet,
                  u_int start_indentation,
                  u_int indentation) {
  using namespace std;

  if (sheet == nullptr)
    return;

  for (auto& rule : *sheet->rules) {
    indent(out, start_indentation);
    out << "<" << rule->selector;

    if (rule->properties) {
      out << " style=\"";

      for (auto& property : *rule->properties) {
        out << property->name << ":" << property->value << ";";
      }

      out << "\"";
    }

    out << ">" << (indentation ? "\n" : "");

    __build_html(out, rule->children, start_indentation + indentation,
                 indentation);

    indent(out, start_indentation);
    out << "</" << rule->selector << ">" << (indentation ? "\n" : "");
  }
}

void build_html(std::ostream& out, const Sheet* sheet, u_int indent) {
  __build_html(out, sheet, 0, indent);
}