#!/usr/bin/env bash

set -e

HOMETIME="18:00:00"
USB_DRIVE_NAME="familia"

HOURS="$1"
PRIVATE_KEY="/Volumes/${USB_DRIVE_NAME}/id_rsa"

main() {
  delete_all_ssh_identities
  add_private_key
  unmount_usb_drive
}

delete_all_ssh_identities() {
  ssh-add -D
}

add_private_key() {
  if [ -z "$HOURS" ]
  then
    add_private_key_until_hometime
  else
    add_private_key_for_hours
  fi
}

add_private_key_until_hometime() {
  local now="$(date +%s)"
  local until="$( date -j -f "%T" $HOMETIME +%s )"
  local seconds_remaining="$( expr $until - $now )"

  if [ "$seconds_remaining" -lt 1 ]
  then
    echo "$HOMETIME is history. Go home!"
    exit 1
  else
    echo "Adding Private key until $HOMETIME..."
    ssh-add -t "$seconds_remaining" "$PRIVATE_KEY"
  fi
}

add_private_key_for_hours() {
  echo "Adding Private Key for $HOURS hours..."
  ssh-add -t "${HOURS}h" "$PRIVATE_KEY"
}

unmount_usb_drive() {
  /usr/sbin/diskutil umount force "/Volumes/$USB_DRIVE_NAME"
}

main
