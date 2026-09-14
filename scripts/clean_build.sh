#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANGLE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Only remove generated output.  The repository's tracked .gn file and source
# checkout must never be deleted by a clean command.
rm -rf \
  "$ANGLE_ROOT/out/Android-arm64-static" \
  "$ANGLE_ROOT/out/Android-arm64-release"

printf 'Removed generated Android ARM64 build directories.\n'