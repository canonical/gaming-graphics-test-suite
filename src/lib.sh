# shellcheck shell=bash
# Shared helpers, sourced by the check scripts.
# shellcheck disable=SC2034 # FAILED is used by the sourcing scripts.

FAILED=0
pass() { echo "PASS: $*"; }
fail() { echo "FAIL: $*"; FAILED=1; }
skip() { echo "SKIP: $*"; }
# check <description> <command...>
check() {
  local desc=$1; shift
  if "$@"; then pass "$desc"; else fail "$desc"; fi
}
# require <command...>: fail and exit if any tool is not installed.
require() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || { fail "$cmd not installed"; exit 1; }
  done
}
