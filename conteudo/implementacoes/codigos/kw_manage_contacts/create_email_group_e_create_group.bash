function create_email_group()
{
  local group_name="$1"
  local values

  validate_group_name "$group_name"

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  check_existent_group "$group_name"

  if [[ "$?" -ne 0 ]]; then
    warning 'This group already exists'
    return 22 # EINVAL
  fi

  create_group "$group_name"

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  return 0
}

function create_group()
{
  local group_name="$1"
  local sql_operation_result

  values="$(format_values_db 1 "$group_name")"

  sql_operation_result=$(insert_into "$DATABASE_TABLE_GROUP" '(name)' "$values" '' 'VERBOSE')
  ret="$?"

  if [[ "$ret" -eq 2 || "$ret" -eq 61 ]]; then
    complain "$sql_operation_result"
    return 22 # EINVAL
  elif [[ "$ret" -ne 0 ]]; then
    complain "($LINENO):" $'Error while inserting group into the database with command:\n' "${sql_operation_result}"
    return 22 # EINVAL
  fi

  return 0
}