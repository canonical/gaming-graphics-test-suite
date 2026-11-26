#!/bin/bash
# vulkaninfo runs and reports a device.
. "$(dirname "$0")/lib.sh"

require vulkaninfo
if ! out=$(vulkaninfo --summary 2>&1); then
  echo "$out"; fail "vulkaninfo --summary"; exit 1
fi
mapfile -t devices < <(grep -oP 'deviceName\s*=\s*\K.*' <<< "$out")
check "Vulkan device(s) found: ${#devices[@]}" test "${#devices[@]}" -gt 0
for d in "${devices[@]}"; do echo "  - $d"; done

# Running vkcube requires a display. We can use virtual displays for
# GH runners (xvfb for X11 and weston headless for wayland).
# This doesn't test the actual pixels being rendered (so it wouldn't catch
# something like a completely black screen). It just ensures that vkcube
# exits with the right return code.
if [ -n "$DISPLAY" ]; then
  require vkcube
  out=$(timeout 30 vkcube --c 100 2>&1); rc=$?
  [ "$rc" -eq 0 ] || echo "$out"
  check "vkcube runs" test "$rc" -eq 0
else
  skip "vkcube (no DISPLAY)"
fi

exit "$FAILED"
