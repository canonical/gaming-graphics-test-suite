# Shared helpers, sourced by the check scripts.
FAILED=0
pass() { echo "PASS: $*"; }
fail() { echo "FAIL: $*"; FAILED=1; }
skip() { echo "SKIP: $*"; }
# check <description> <command...>
check() { d=$1; shift; if "$@"; then pass "$d"; else fail "$d"; fi; }
# Upstream X.Y.Z from any version string.
xyz() { grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1; }
# Software-renderer checks run unless SOFTWARE_RENDERING=0.
software() { [ "${SOFTWARE_RENDERING:-1}" = 1 ]; }
TRIPLET="$(uname -m)-linux-gnu"
