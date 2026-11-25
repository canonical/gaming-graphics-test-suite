#!/bin/bash
# vulkaninfo runs and reports the expected Mesa driver.
. "$(dirname "$0")/lib.sh"

if ! out=$(vulkaninfo --summary 2>&1); then
  echo "$out"; fail "vulkaninfo --summary"; exit 1
fi
if software; then
  check "lavapipe (CPU) device present" grep -q 'deviceType.*CPU' <<< "$out"
else
  check "Vulkan device present" grep -q 'deviceType' <<< "$out"
fi

if [ -n "$EXPECTED_MESA_VERSION" ]; then
  want=$(xyz <<< "$EXPECTED_MESA_VERSION")
  got=$(grep driverInfo <<< "$out" | xyz)
  check "driverInfo Mesa $got == $want" test "$got" = "$want"
else
  skip "Mesa version (EXPECTED_MESA_VERSION unset)"
fi

exit $FAILED
