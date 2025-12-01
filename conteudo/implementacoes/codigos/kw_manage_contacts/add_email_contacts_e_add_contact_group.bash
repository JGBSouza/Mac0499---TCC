function add_email_contacts()
{
  local contacts_list="$1"
  local group_name="$2"
  local group_id
  declare -A _contacts_array

  if [[ -z "$contacts_list" ]]; then
    complain 'The contacts list is empty'
    return 61 # ENODATA
  fi

  if [[ -z "$group_name" ]]; then
    complain 'The group name is empty'
    return 61 # ENODATA
  fi

  check_existent_group "$group_name"
  group_id="$?"

  if [[ "$group_id" -eq 0 ]]; then
    complain 'Error, ubable to add contacts to unexistent group'
    return 22 # EINVAL
  fi

  split_contact_infos "$contacts_list" _contacts_array

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  add_contacts _contacts_array

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  add_contact_group _contacts_array "$group_id"

  if [[ "$?" -ne 0 ]]; then
    return 22 # EINVAL
  fi

  return 0
}

# This function add the association between the contacts
# and its group in the database
#
# @contacts_array: The contact name
# @group_id: The id of group which the contacts will be associated
#
# Returns:
# returns 0 if successful, non-zero otherwise
function add_contact_group()
{
  local -n contacts_array="$1"
  local group_id="$2"
  local values
  local email
  local contact_id
  local ctt_group_association
  local sql_operation_result
  local ret

  for email in "${!contacts_array[@]}"; do
    condition_array=(['email']="${email}")
    contact_id="$(select_from "$DATABASE_TABLE_CONTACT" 'id' '' 'condition_array')"
    values="$(format_values_db 2 "$contact_id" "$group_id")"

    condition_array=(['contact_id']="${contact_id}" ['group_id']="${group_id}")
    ctt_group_association="$(select_from "$DATABASE_TABLE_CONTACT_GROUP" 'contact_id, group_id' '' 'condition_array')"
    if [[ -n "$ctt_group_association" ]]; then
      continue
    fi

    sql_operation_result=$(insert_into "$DATABASE_TABLE_CONTACT_GROUP" '(contact_id, group_id)' "$values" '' 'VERBOSE')
    ret="$?"

    if [[ "$ret" -eq 2 || "$ret" -eq 61 ]]; then
      complain "$sql_operation_result"
      return 22 # EINVAL
    elif [[ "$ret" -ne 0 ]]; then
      complain "($LINENO):" $'Error while trying to insert contact group into the database with the command:\n'"${sql_operation_result}"
      return 22 # EINVAL
    fi

  done

  return 0
}