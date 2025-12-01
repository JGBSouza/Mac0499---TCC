# update one row using one unique attribute
condition_array=(['name']='name19')
updates_array=(['attribute1']='att1.2' ['attribute2']='att2.2' ['rank']='10')
update_into 'fake_table' 'updates_array' '' 'condition_array'