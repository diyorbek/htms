#include "html_builder.hh"

#include <format>
#include <iomanip>
#include <string>

void indent(std::ostream& out, u_int indentation) {
  using namespace std;
  fill_n(ostream_iterator<char>(out), indentation, ' ');
}

void _build_html(std::ostream& out, const Sheet* sheet, u_int start_indentation,
                 u_int indentation) {
  using namespace std;

  if (sheet == nullptr) return;

  for (auto& rule : *sheet->rules) {
    indent(out, start_indentation);

    string tag = rule->selector;
    string id_or_class;
    if (!tag.empty() && (tag[0] == '.' || tag[0] == '#')) {
      id_or_class = string(" ") + (tag[0] == '.' ? "class" : "id") + "=\"" +
                    tag.substr(1) + "\"";
      tag         = "div";
    }

    out << "<" << tag << id_or_class;

    if (rule->properties) {
      out << " style=\"";

      for (auto& property : *rule->properties) {
        out << property->name << ":" << property->value << ";";
      }

      out << "\"";
    }

    out << ">" << (indentation ? "\n" : "");

    _build_html(out, rule->children, start_indentation + indentation,
                indentation);

    indent(out, start_indentation);
    out << "</" << tag << ">" << (indentation ? "\n" : "");
  }
}

void build_html(std::ostream& out, const Sheet* sheet, u_int indent) {
  _build_html(out, sheet, 0, indent);
}