function show_email_groups()
{
  local group_name="$1"
  local columns="$2"
  local groups_info
  local contacts_info
  local contact_id
  declare -a contacts_array
  declare -a groups_array

  if [[ -n "$group_name" ]]; then

    check_existent_group "$group_name"

    if [[ "$?" -eq 0 ]]; then
      complain 'Error unexistent group'
      return 22 #EINVAL
    fi

    contacts_info="$(get_groups_contacts_infos "$group_name" '*')"
    IFS=',' read -ra contacts_array <<< "$contacts_info"
    print_contact_infos "$group_name" 'contacts_array' "$columns"
    return
  fi

  groups_info="$(select_from "$DATABASE_TABLE_GROUP")"
  readarray -t groups_array <<< "$groups_info"
  print_groups_infos 'groups_array' "$columns"
}

function print_contact_infos()
{
  local group_name="$1"
  local -n _contacts_array="$2"
  local columns="$3"
  local group_name_width=${#group_name}
  local trim_width=$(((columns - group_name_width) / 2))
  local remaining_width=$((columns - group_name_width - trim_width))
  local id_width=8
  local name_width=50
  local associate_groups_width=20
  local created_at_width=12
  local email_width=$((columns - id_width - name_width - associate_groups_width - created_at_width - 8))

  if [[ -z $columns ]]; then
    columns="$(tput cols)"
  fi

  printf "%*s%s%*s\n" "$trim_width" "" "$group_name" "$remaining_width" "" | tr ' ' '-'

  printf "%-${id_width}s|%-${name_width}s|%-${email_width}s|" \
       "%-${associate_groups_width}s|%-${created_at_width}s\n" \
       "ID" "Name" "Email" "Associated Groups" "Created at"

  printf "%-${columns}s\n" | tr ' ' '-'

  for contact in "${_contacts_array[@]}"; do
    IFS='|' read -r id name email created_at <<< "$contact"
    condition_array=(['contact_id']="$id")
    associate_groups_num="$(select_from "$DATABASE_TABLE_CONTACT_GROUP" 'COUNT(*)' '' 'condition_array')"
    printf "%-${id_width}s|%-${name_width}s|%-${email_width}s|" \
       "%-${associate_groups_width}s|%-${created_at_width}s\n" \
       "$id" "$name" "$email" "$associate_groups_num" "$created_at"

  done
  printf "%-${columns}s\n" | tr ' ' '-'

}

function print_groups_infos()
{
  local -n groups_info="$1"
  local columns="$2"
  local id_width=8
  local contact_num_width=25
  local created_at_width=20
  local name_width=$(("$columns" - id_width - contact_num_width - created_at_width - 6))

  if [[ -z $columns ]]; then
    columns="$(tput cols)"
  fi

  printf "%-${id_width}s|%-${name_width}s|%-${contact_num_width}s|%-${created_at_width}s\n" "ID" "Name" "Contacts" "Created at"
  printf "%-${columns}s\n" | tr ' ' '-'

  for group in "${!groups_info[@]}"; do
    IFS='|' read -r id name created_at <<< "${groups_info[$group]}"
    condition_array=(['group_id']="$id")
    contact_num="$(select_from "$DATABASE_TABLE_CONTACT_GROUP" 'COUNT(*)' '' 'condition_array')"
    printf "%-${id_width}s|%-${name_width}s|%-${contact_num_width}s|%-${created_at_width}s\n" "$id" "$name" "$contact_num" "$created_at"
  done

  printf "%-${columns}s\n" | tr ' ' '-'
}