#!/bin/bash
# Run every check against whatever graphics stack the current environment
# provides: the host's, or a snap's via `snap run --shell <consumer>`.

cd "$(dirname "$0")" || exit 1
log=$(mktemp)
trap 'rm -f "$log"' EXIT

rc=0
for t in icd.sh vulkan.sh gl.sh; do
  echo "== $t"
  ./"$t" | tee -a "$log"
  [ "${PIPESTATUS[0]}" -eq 0 ] || rc=1
done

count() { grep -c "^$1:" "$log"; }
echo "== Summary: $(count PASS) passed, $(count FAIL) failed, $(count SKIP) skipped"
exit $rc
