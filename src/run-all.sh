#!/bin/bash
# Run every check against whatever graphics stack the current environment
# provides: the host's, or a snap's via `snap run --shell <consumer>`.
#
# SOFTWARE_RENDERING=1 (default) forces llvmpipe / lavapipe and checks for them;
# set SOFTWARE_RENDERING=0 to test whatever drivers the environment selects.
# LIBGL_ALWAYS_SOFTWARE / VK_LOADER_DRIVERS_SELECT are only defaulted, so
# callers can override them either way.
export SOFTWARE_RENDERING="${SOFTWARE_RENDERING:-1}"
if [ "$SOFTWARE_RENDERING" = 1 ]; then
  export LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE-1}"
  export VK_LOADER_DRIVERS_SELECT="${VK_LOADER_DRIVERS_SELECT-*lvp*}"
fi

cd "$(dirname "$0")" || exit 1
rc=0
for t in icd.sh vulkan.sh gl.sh; do
  echo "== $t"
  ./"$t" || rc=1
done
exit $rc
