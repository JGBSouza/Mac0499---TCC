# This function removes every matching row from a given table.
#
# @table:     Table to replace/insert data into
# @_condition_array: An array reference of condition pairs
#                    <column,value> to match rows
# @db:        Name of the database file
# @db_folder: Path to the folder that contains @db
#
# Return:
# 2 if db doesn't exist;
# 22 if empty table, columns or values are passed;
# 0 if succesful.
function remove_from()
    {
        local table="$1"
        local -n _condition_array="$2"
        local db="${3:-"${DB_NAME}"}"
        local db_folder="${4:-"${KW_DATA_DIR}"}"
        local flag=${5:-'SILENT'}
        local where_clause=''
        local db_path
        db_path="$(join_path "${db_folder}" "$db")"
        if [[ ! -f "${db_path}" ]]; then
        complain 'Database does not exist'
        return 2
        fi

        if [[ -z "$table" || -z "${!_condition_array[*]}" ]]; then
        complain 'Empty table or condition array.'
        return 22 # EINVAL
        fi

        for column in "${!_condition_array[@]}"; do
        where_clause+="$column='${_condition_array["${column}"]}'"
        where_clause+=' AND '
        done
        # Remove trailing ' AND '
        where_clause="${where_clause::-5}"

        cmd="sqlite3 -init "${KW_DB_DIR}/pre_cmd.sql" \"${db_path}\" -batch \"DELETE FROM ${table} WHERE ${where_clause};\""
        cmd_manager "$flag" "$cmd"
    }