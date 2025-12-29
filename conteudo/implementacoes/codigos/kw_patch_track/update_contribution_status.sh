function update_contribution_status()
{
  condition_array=(['id']="$contribution_id")
  contribution_repository_id="$(get_contribution_info 'repository_id' 'condition_array')"

  condition_array=(['id']="$contribution_repository_id")
  repository_origin_url="$(get_repository_info 'origin_url' 'condition_array')"

  submission_id="$(get_last_submission_infos_by_contribution_id 'id' "$contribution_id")" || return 22
  condition_array=(['submission_id']="$submission_id")

  patch_submission_infos="$(
    get_patch_submission_info 'patch_id, submission_id, message_id' 'condition_array'
  )" || return 22

  for patch_id in $patch_submission_infos; do
    IFS='|' read -r patch_id submission_id message_id <<< "$patch_submission_infos"

    condition_array=(['patch_id']="$patch_id"
      ['submission_id']="$submission_id"
      ['message_id']="$message_id")
    message_id="$(get_patch_submission_info 'message_id' 'condition_array')" || continue

    condition_array=(['id']="$patch_id")
    patch_infos="$(get_patch_info 'commit_hash, status' 'condition_array')" || continue

    IFS='|' read -r commit_hash status <<< "$patch_infos"

    final_status="$(
      update_patch_status \
        "$patch_id" \
        "$message_id" \
        "$commit_hash" \
        "$status"
    )"
    patches_status["$patch_id"]="$final_status"
  done

  decide_contribution_status "$contribution_id" 'patches_status'
  show_contributions_dashboard '' '' "$contribution_id"
}