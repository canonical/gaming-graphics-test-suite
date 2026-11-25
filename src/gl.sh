#!/bin/bash
# glxinfo runs and reports the expected Mesa renderer.
. "$(dirname "$0")/lib.sh"

[ -n "$DISPLAY" ] || { skip "glxinfo (no DISPLAY)"; exit 0; }
if ! out=$(glxinfo -B 2>&1); then
  echo "$out"; fail "glxinfo -B"; exit 1
fi
check "direct rendering"   grep -q 'direct rendering: Yes' <<< "$out"
check "llvmpipe renderer"  grep -q 'OpenGL renderer string:.*llvmpipe' <<< "$out"

if [ -n "$EXPECTED_MESA_VERSION" ]; then
  want=$(xyz <<< "$EXPECTED_MESA_VERSION")
  got=$(grep -m1 'OpenGL.*version string:.*Mesa' <<< "$out" | sed 's/.*Mesa//' | xyz)
  check "GL Mesa $got == $want" test "$got" = "$want"
else
  skip "Mesa version (EXPECTED_MESA_VERSION unset)"
fi

exit $FAILED
