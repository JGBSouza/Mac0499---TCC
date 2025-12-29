function update_patch_status()
{
  if [[ "$patch_current_status" == 'MERGED' ]]; then
    printf '%s' 'MERGED'
    return 0
  fi

  [[ -f '/tmp/mutt-status' ]] && rm -f '/tmp/mutt-status'

  xterm -iconic -e \
    sh -c "mutt -F ${MUTT_RC_PATH} \
      -e 'push \"l ((~i ${patch_message_id})|(~x ${patch_message_id})) ~b .* <enter><pause><enter>q\"' \
      ; echo finished > /tmp/mutt-status" \
    > /dev/null 2>&1 &

  while [[ ! -s '/tmp/mutt-status' ]]; do
    sleep 0.1
  done

  mapfile -t reply_files < <(grep -R -l "In-Reply-To:.*${patch_message_id}" "$KW_MUTT_MESSAGES_DIR")

  if [[ "${#reply_files[@]}" -eq 0 ]]; then
    set_patch_status "$patch_id" 'SENT'
    printf '%s' 'SENT'
    return 0
  fi

  for file in "${reply_files[@]}"; do
    if grep -Eiw "Approved|Reviewed-by" "$file" > /dev/null 2>&1; then
      set_patch_status "$patch_id" 'APPROVED'
      printf '%s' 'APPROVED'
      return 0
    fi
  done

  last_msg_file=$(printf '%s\n' "${reply_files[@]}" |
    xargs -d '\n' stat --format='%Y %n' 2> /dev/null |
    sort -n |
    tail -n1 |
    cut -d' ' -f2-)

  if [[ -z "$last_msg_file" ]]; then
    set_patch_status "$patch_id" 'SENT'
    printf '%s' 'SENT'
    return 0
  fi

  last_author=$(grep -i '^From:' "$last_msg_file" |
    sed -E 's/From:.*<([^>]+)>.*/\1/')

  if [[ "$last_author" == "${patch_track_mutt_config['imap_user']}" ]]; then
    set_patch_status "$patch_id" 'SENT'
    printf '%s' 'SENT'
  else
    set_patch_status "$patch_id" 'REVIEWED'
    printf '%s' 'REVIEWED'
  fi

  return 0
}