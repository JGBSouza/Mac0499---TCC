function rename_group()
{
  local old_name="$1"
  local new_name="$2"
  local sql_operation_result
  local ret

  condition_array=(['name']="${old_name}")
  updates_array=(['name']="${new_name}")

  sql_operation_result=$(update_into "$DATABASE_TABLE_GROUP" 'updates_array' '' 'condition_array' 'VERBOSE')
  ret="$?"

  if [[ "$ret" -eq 2 || "$ret" -eq 61 ]]; then
    complain "$sql_operation_result"
    return 22 # EINVAL
  elif [[ "$ret" -ne 0 ]]; then
    complain "($LINENO):" $'Error while removing group from the database with command:\n'"${sql_operation_result}"
    return 22 # EINVAL
  fi

  return 0
}