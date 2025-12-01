# This function receives a condition_array and then generate
# the infos that will be used by the WHERE clause to specify
# the data whe want.
#
# @condition_array_ref: The condition array containing the conditions
#
# Returns:
# A string containing the generated clause
function generate_where_clause()
{
  local -n condition_array_ref="$1"
  local clause
  local relational_op='='
  local attribute
  local where_clause="WHERE "
  local value

  for clause in "${!condition_array_ref[@]}"; do
    attribute="$(cut --delimiter=',' --fields=1 <<< "$clause")"
    value="${condition_array_ref["${clause}"]}"

    if [[ "$clause" =~ "," ]]; then
      relational_op=$(cut --delimiter=',' --fields=2 <<< "$clause")
    fi

    where_clause+="${attribute}${relational_op}'${value}'"
    where_clause+=' AND '
  done

  printf '%s' "${where_clause::-5}" # Remove trailing ' AND '
}