#!/bin/bash

# sheet
empty_rule_list=""
wh_empty_rule_list="

  "
compact_rule_list="selector{property:123;}"

# selectors
alphanumeric_selector="selector1 {}"
mixed_char_selector="selector-1_ {}"
selector_list="selector {} selector {}"
special_selectors=".selector {} #selector {}"
nested_selector="selector {nested-selector {}}"
spaced_rule_list="selector {
  property: 123;

  property: 123;
}"

# properties
dashed_property="selector{
  proper-ty: 123;
  -pro-perty: 123;
}"
variable_property="selector{
  --v: 123;
}"
alphanumeric_variable_property="selector{
  --v123: 123;
}"

# values
numeric_value="selector{
  property: 123;
  property: -123;
}"
unit_value="selector{
  property: 123px;
  property: 123abc;
  property: -123vh;
}"
alpha_value="selector{
  property: value;
  property: value-value;
}"
string_value="selector{
  property: 'value';
  property: \"value\";
}"
combined_value="selector{
  property: value -123 va-lue 123s -1;
}"

for variable in $(compgen -v | grep -E "(rule_list|selector|property|value)"); do
    result=`echo "${!variable}" | ./htms 2>&1 > /dev/null`
    if [ ${#result} == "0" ]; then
      echo -e "\033[32m" $variable
    else
      echo -e "\033[31m" $variable
    fi
done

check_output() {
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(echo "$input" | ./htms 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
      echo -e "\033[32m" $name
    else
      echo -e "\033[31m" $name
      echo "  expected: $(echo "$expected" | tr '\n' '|')"
      echo "  actual:   $(echo "$actual" | tr '\n' '|')"
    fi
}

check_output "multi-token unit value" \
    "a { margin: 10px 5px; }" \
    "<a style=\"margin:10px 5px;\">
</a>"

check_output "many-token unit value" \
    "a { p: 1px 2px 3px 4px 5px 6px 7px 8px 9px 10px; }" \
    "<a style=\"p:1px 2px 3px 4px 5px 6px 7px 8px 9px 10px;\">
</a>"

check_output "multi-token identifier value" \
    "a { font: bold italic large; }" \
    "<a style=\"font:bold italic large;\">
</a>"
