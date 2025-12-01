# This function gets the values in the table of given database
#
# @flag:      Flag to control function output
# @table:     Table to select info from
# @columns:   Columns of the table to get
# @pre_cmd:   Pre command to execute
# @order_by:  List of attributes to use for ordering
# @db:        Name of the database file
# @db_folder: Path to the folder that contains @db
#
# Return:
# 2 if db doesn't exist; 22 if table is empty
# 0 if succesful; non-zero otherwise
function select_from()
{
  local table="$1"
  local columns="${2:-"*"}"
  local pre_cmd="$3"
  local order_by="$4"
  local flag=${5:-'SILENT'}
  local db="${6:-$DB_NAME}"
  local db_folder="${7:-$KW_DATA_DIR}"
  local db_path
  local query
  local cmd

  db_path="$(join_path "$db_folder" "$db")"

  if [[ ! -f "$db_path" ]]; then
    complain 'Database does not exist'
    return 2
  fi
  if [[ -z "$table" ]]; then
    complain 'Empty table.'
    return 22 # EINVAL
  fi

  query="SELECT $columns FROM $table ;"
  if [[ -n "${order_by}" ]]; then
    query="SELECT $columns FROM $table ORDER BY ${order_by} ;"
  fi

  cmd="sqlite3 -init ${KW_DB_DIR}/pre_cmd.sql -cmd \"${pre_cmd}\" \"${db_path}\" -batch \"${query}\""
  cmd_manager "$flag" "$cmd"
}