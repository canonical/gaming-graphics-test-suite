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
run_vkcube() { # $1 = wsi (xcb|wayland)
  require vkcube
  out=$(vkcube --c 100 --wsi "$1" 2>&1); rc=$?
  [ "$rc" -eq 0 ] || echo "$out"
  check "vkcube runs ($1)" test "$rc" -eq 0
}

if [ -n "$DISPLAY" ]; then
  run_vkcube xcb
else
  skip "vkcube x11 (no DISPLAY)"
fi

if [ -n "$WAYLAND_DISPLAY" ]; then
  run_vkcube wayland
else
  skip "vkcube wayland (no WAYLAND_DISPLAY)"
fi

exit "$FAILED"
