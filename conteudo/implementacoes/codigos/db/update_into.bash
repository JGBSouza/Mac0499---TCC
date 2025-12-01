# This function update the set of values in the table of given database
# with the given conditions.
#
# @table:     Table to select info from
# @set:   An array reference of condition pairs that will be
# updated in the db
# @pre_cmd:   Pre command to execute
# @_condition_array: An array reference of condition pairs
# specifing the data that will be updated
# @flag:      Flag to control function output
# @db:        Name of the database file
# @db_folder: Path to the folder that contains @db
#
# Return:
# 2 if db doesn't exist; 22 if table is empty
# 0 if succesful; non-zero otherwise
function update_into()
{
  local table="$1"
  local _updates_array="$2"
  local pre_cmd="$3"
  local _condition_array="$4"
  local flag=${5:-'SILENT'}
  local db="${6:-"$DB_NAME"}"
  local db_folder="${7:-"$KW_DATA_DIR"}"
  local where_clause=''
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
