function remove_email_group()
{
  local group_name="$1"

  check_existent_group "$group_name"

  if [[ "$?" -eq 0 ]]; then
    warning 'Error, this group does not exist'
    return 22 #EINVAL
  fi

  remove_group "$group_name"

  if [[ "$?" -ne 0 ]]; then
    return 22 #EINVAL
  fi

  return 0
}

function remove_group()
{
  local group_name="$1"
  local sql_operation_result

  condition_array=(['name']="${group_name}")

  sql_operation_result=$(remove_from "$DATABASE_TABLE_GROUP" 'condition_array' '' '' 'VERBOSE')
  ret="$?"

  if [[ "$ret" -eq 2 || "$ret" -eq 61 ]]; then
    complain "$sql_operation_result"
    return 22 # EINVAL
  elif [[ "$ret" -ne 0 ]]; then
    complain $'Error while removing group from the database with command:\n'"${sql_operation_result}"
    return 22 # EINVAL
  fi

  return 0
}