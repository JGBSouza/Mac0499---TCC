 function remove_from()
 {
  local table="$1"
  local _condition_array="$2"
  local db="${3:-"${DB_NAME}"}"
  local db_folder="${4:-"${KW_DATA_DIR}"}"
  local flag=${5:-'SILENT'}

  local db_path
  db_path="$(join_path "${db_folder}" "$db")"
  if [[ ! -f "${db_path}" ]]; then
    complain 'Database does not exist'
    return 2
  fi

  if [[ -z "$table" || -z "$_condition_array" ]]; then
    complain 'Empty table or condition array.'
    return 22 # EINVAL
  fi

  where_clause="$(generate_where_clause "$_condition_array")"
  query="DELETE FROM ${table} ${where_clause} ;"

  cmd="sqlite3 -init "${KW_DB_DIR}/pre_cmd.sql" \"${db_path}\" -batch \"$query\""
  cmd_manager "$flag" "$cmd"
}