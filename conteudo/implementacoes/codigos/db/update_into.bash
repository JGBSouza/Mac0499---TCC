function update_into()
{
  db_path="$(join_path "$db_folder" "$db")"

  if [[ ! -f "$db_path" ]]; then
    complain 'Database does not exist'
    return 2
  fi

  if [[ -z "$table" ]]; then
    complain 'Empty table.'
    return 22 # EINVAL
  fi

  if [[ -z "$_condition_array" || -z "$_updates_array" ]]; then
    complain 'Empty condition or updates array.'
    return 22 #EINVAL
  fi

  where_clause="$(generate_where_clause "$_condition_array")"
  set_clause="$(generate_set_clause "$_updates_array")"

  query="UPDATE ${table} SET ${set_clause} ${where_clause} ;"

  cmd="sqlite3 -init "${KW_DB_DIR}/pre_cmd.sql" -cmd \"${pre_cmd}\" \"${db_path}\" -batch \"$query\""
  cmd_manager "$flag" "$cmd"
}
