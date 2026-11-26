#!/bin/bash
# Vulkan ICD manifests point at libraries that exist.
. "$(dirname "$0")/lib.sh"

# Resolve a manifest's library_path the way the Vulkan loader does:
#   /abs/path      -> as-is
#   rel/path.so    -> relative to the manifest's directory
#   libname.so     -> dynamic linker search (LD_LIBRARY_PATH, then ldconfig cache)
# Prints the resolved path, or nothing if a bare name isn't found.
resolve_lib() {
  local manifest=$1 lib=$2 dir
  case $lib in
    /*) echo "$lib" ;;
    */*) echo "$(dirname "$manifest")/$lib" ;;
    *)
      local IFS=:
      for dir in $LD_LIBRARY_PATH; do
        [ -n "$dir" ] && [ -e "$dir/$lib" ] && { echo "$dir/$lib"; return; }
      done
      PATH=$PATH:/sbin:/usr/sbin ldconfig -p 2>/dev/null |
        awk -v n="$lib" '$1 == n { print $NF; exit }'
      ;;
  esac
}

# Loader's override list if set, else the system default location.
if [ -n "$VK_DRIVER_FILES" ]; then
  IFS=: read -ra manifests <<< "$VK_DRIVER_FILES"
else
  shopt -s nullglob
  manifests=(/usr/share/vulkan/icd.d/*.json)
fi
[ "${#manifests[@]}" -gt 0 ] || { fail "no ICD manifests found"; exit 1; }

broken=()
for m in "${manifests[@]}"; do
  name=$(basename "$m")
  lib=$(sed -nE 's/.*"library_path"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$m")
  if [ -z "$lib" ]; then
    broken+=("$name: no library_path")
  elif [ ! -e "$(resolve_lib "$m" "$lib")" ]; then
    broken+=("$name -> $lib")
  fi
done

total=${#manifests[@]}
if [ "${#broken[@]}" -eq 0 ]; then
  pass "all $total ICD manifests point at existing libraries"
else
  fail "${#broken[@]} of $total ICD manifests point at missing libraries"
  printf '  - %s\n' "${broken[@]}"
fi

exit "$FAILED"
