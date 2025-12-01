function rename_email_group()
{
  local old_name="$1"
  local new_name="$2"
  local group_id

  if [[ -z "$old_name" ]]; then
    complain 'Error, group name is empty'
    return 61 # ENODATA
  fi

  check_existent_group "$old_name"

  if [[ "$?" -eq 0 ]]; then
    warning 'This group does not exist so it can not be renamed'
    return 22 # EINVAL
  fi

  validate_group_name "$new_name"

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  rename_group "$old_name" "$new_name"

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  return 0
}

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