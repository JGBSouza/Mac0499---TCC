condition_array=(['name']="${config_name}")
is_on_database="$(select_from 'kernel_config' '' '' 'condition_array' '' "$flag")"