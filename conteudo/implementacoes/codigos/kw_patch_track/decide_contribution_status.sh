function decide_contribution_status()
{
  local contribution_id="$1"
  local -n _contribution_patches_status="$2"
  local has_revisado=0
  local has_aprovado=0
  local has_mergeado=0
  local has_sent=0

  for pid in "${!_contribution_patches_status[@]}"; do
    case "${_contribution_patches_status[$pid]}" in
      REVIEWED) has_revisado=1 ;;
      APPROVED) has_aprovado=1 ;;
      MERGED) has_mergeado=1 ;;
      SENT) has_sent=1 ;;
    esac
  done

  if [[ $has_revisado -eq 1 ]]; then
    contribution_status="REVIEWED"
  elif [[ $has_aprovado -eq 1 ]]; then
    contribution_status="APPROVED"
  elif [[ $has_sent -eq 1 ]]; then
    contribution_status="SENT"
  elif [[ $has_mergeado -eq 1 ]]
    contribution_status="MERGED"
  fi

  condition_array=(['id']="$contribution_id")
  set_contribution_status "$contribution_id" "$contribution_status"

  return 0
}