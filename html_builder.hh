#pragma once

#include "ast.hh"

#include <sstream>

void build_html(std::ostream& out, const Sheet* sheet, u_int indent = 0);