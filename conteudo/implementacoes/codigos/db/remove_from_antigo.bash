function remove_from()
{
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