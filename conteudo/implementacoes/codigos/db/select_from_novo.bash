function select_from()
{
  local table="$1"
  local columns="${2:-"*"}"
  local pre_cmd="$3"
  local _condition_array="$4"
  local order_by=${5:-''}
  local flag=${6:-'SILENT'}
  local db="${7:-"$DB_NAME"}"
  local db_folder="${8:-"$KW_DATA_DIR"}"
  local where_clause
  local db_path
  local query

  db_path="$(join_path "$db_folder" "$db")"

  if [[ ! -f "$db_path" ]]; then
    complain 'Database does not exist'
    return 2
  fi
  if [[ -z "$table" ]]; then
    complain 'Empty table.'
    return 22 # EINVAL
  fi

  if [[ -n "$_condition_array" ]]; then
    where_clause="$(generate_where_clause "$_condition_array")"
  fi

  query="SELECT ${columns} FROM ${table} ${where_clause} ;"

  if [[ -n "${order_by}" ]]; then
    query="${query::-2} ORDER BY ${order_by} ;"
  fi

  cmd="sqlite3 -init "${KW_DB_DIR}/pre_cmd.sql" -cmd \"${pre_cmd}\" \"${db_path}\" -batch \"$query\""
  cmd_manager "$flag" "$cmd"
}