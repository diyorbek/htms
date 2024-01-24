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
    result=`echo ${!variable} | ./parser 2>&1 > /dev/null`
    if [ ${#result} == "0" ]; then
      echo -e "\033[32m" $variable
    else
      echo -e "\033[31m" $variable
    fi
done
