function send_patch_main()
{
  local flag
  flag=${flag:-'SILENT'}
  if [[ "$1" =~ -h|--help ]]; then
    send_patch_help "$1"
	@@ -89,7 +90,9 @@
  local flag="$1"
  local opts="${send_patch_config[send_opts]}"
  local to_recipients="${options_values['TO']}"
  local to_groups_recipients="${options_values['TO_GROUPS']}"
  local cc_recipients="${options_values['CC']}"
  local cc_groups_recipients="${options_values['CC_GROUPS']}"
  local dryrun="${options_values['SIMULATE']}"
  local commit_range="${options_values['COMMIT_RANGE']}"
  local version="${options_values['PATCH_VERSION']}"
  local extra_opts="${options_values['PASS_OPTION_TO_SEND_EMAIL']}"
  local private="${options_values['PRIVATE']}"
  local rfc="${options_values['RFC']}"
  local kernel_root
  local patch_count=0
  local cmd='git send-email'
  flag=${flag:-'SILENT'}

  [[ -n "$dryrun" ]] && cmd+=" $dryrun"

  if [[ -n "$to_groups_recipients" ]]; then
    validate_email_group_list "$to_groups_recipients" || exit_msg 'Please review your `--to-groups` list.'
    if [[ -n "$to_recipients" ]]; then
      to_recipients+=','
    fi
    to_recipients+=$(get_groups_contacts_infos "$to_groups_recipients" 'email')
  fi

  if [[ -n "$cc_groups_recipients" ]]; then
    validate_email_group_list "$cc_groups_recipients" || exit_msg 'Please review your `--cc-groups` list.'
    if [[ -n "$cc_recipients" ]]; then
      cc_recipients+=','
    fi
    cc_recipients+=$(get_groups_contacts_infos "$cc_groups_recipients" 'email')
  fi

  if [[ -n "$to_recipients" ]]; then
    validate_email_list "$to_recipients" || exit_msg 'Please review your `--to` list.'
    cmd+=" --to=\"$to_recipients\""
  fi
  if [[ -n "$cc_recipients" ]]; then
    validate_email_list "$cc_recipients" || exit_msg 'Please review your `--cc` list.'
    cmd+=" --cc=\"$cc_recipients\""
  fi
  # Don't generate a cover letter when sending only one patch
  patch_count="$(pre_generate_patches "$commit_range" "$version")"
  if [[ "$patch_count" -eq 1 ]]; then
    opts="$(sed 's/--cover-letter//g' <<< "$opts")"
  fi
  kernel_root="$(find_kernel_root "$PWD")"
  # if inside a kernel repo use get_maintainer to populate recipients
  if [[ -z "$private" && -n "$kernel_root" ]]; then
    generate_kernel_recipients "$kernel_root"
    cmd+=" --to-cmd='bash ${KW_PLUGINS_DIR}/kw_mail/to_cc_cmd.sh ${KW_CACHE_DIR} to'"
    cmd+=" --cc-cmd='bash ${KW_PLUGINS_DIR}/kw_mail/to_cc_cmd.sh ${KW_CACHE_DIR} cc'"
  fi
	@@ -931,27 +950,27 @@
    [[ "$1" =~ ^--$ ]] && dash_dash=1
    # The added quotes ensure arguments are correctly separated
    options="$options \"$1\""
    shift
  done
  if [[ -n "$commit_count" ]]; then
    # add `--` if not present
    [[ "$dash_dash" == 0 ]] && options="$options --"
    options="$options $commit_count"
  fi
  printf '%s' "$options"
}