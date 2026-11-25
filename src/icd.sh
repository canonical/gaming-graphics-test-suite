#!/bin/bash
# Vulkan ICD manifests point at libraries that exist.
. "$(dirname "$0")/lib.sh"

# Loader's override list if set, else the system default location.
IFS=: read -ra manifests <<< "${VK_DRIVER_FILES:-$(ls /usr/share/vulkan/icd.d/*.json 2>/dev/null | paste -sd:)}"
check "ICD manifests found" test "${#manifests[@]}" -gt 0

lvp=no
for m in "${manifests[@]}"; do
  lib=$(sed -nE 's/.*"library_path"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$m")
  case $lib in
    */"$TRIPLET"/*) check "$(basename "$m") -> $lib exists" test -e "$lib" ;;
  esac
  case $lib in *libvulkan_lvp*) lvp=yes ;; esac
done
check "lavapipe ICD present" test $lvp = yes

exit $FAILED
