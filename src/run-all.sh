#!/bin/bash
# Run every check against whatever graphics stack the current environment
# provides: the host's, or a snap's via `snap run --shell <consumer>`.
# Software rendering only (llvmpipe / lavapipe).
export LIBGL_ALWAYS_SOFTWARE=1
export VK_LOADER_DRIVERS_SELECT='*lvp*'

cd "$(dirname "$0")" || exit 1
rc=0
for t in icd.sh vulkan.sh gl.sh; do
  echo "== $t"
  ./"$t" || rc=1
done
exit $rc
