#!/bin/bash
# glxinfo runs and reports a renderer.
. "$(dirname "$0")/lib.sh"

[ -n "$DISPLAY" ] || { skip "glxinfo (no DISPLAY)"; exit 0; }
require glxinfo
if ! out=$(glxinfo -B 2>&1); then
  echo "$out"; fail "glxinfo -B"; exit 1
fi
check "direct rendering" grep -q 'direct rendering: Yes' <<< "$out"
renderer=$(sed -n 's/.*OpenGL renderer string:[[:space:]]*//p' <<< "$out")
check "renderer: ${renderer:-none}" test -n "$renderer"

# Unlike vkcube, there's no option we can set in glxgears to get it to
# quit after a certain number of frames or seconds. So we just test if
# it runs for 5s without crashing. Timeout has an exit code of 124.
# TODO: uncomment when timeout is allowed under snap strict confinement.
# require glxgears
# out=$(timeout 5 glxgears 2>&1); rc=$?
# [ "$rc" -eq 124 ] || echo "$out"
# check "glxgears runs" test "$rc" -eq 124

exit "$FAILED"
