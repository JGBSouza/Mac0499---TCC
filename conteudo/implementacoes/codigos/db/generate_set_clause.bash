function generate_set_clause()
{
  local -n condition_array_ref="$1"
  local attribute
  local set_clause
  local value

  for attribute in "${!condition_array_ref[@]}"; do
    value="${condition_array_ref["${attribute}"]}"
    set_clause+="${attribute} = '${value}'"
    set_clause+=', '
  done

  printf '%s' "${set_clause::-2}" # Remove trailing ', '
}