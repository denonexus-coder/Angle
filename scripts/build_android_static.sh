#!/usr/bin/env bash
set -euo pipefail

# Build ANGLE static archives for Android arm64-v8a with an ARMv8.0-A
# instruction-set baseline.  ARMv8.1-A and newer extensions are not enabled.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANGLE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="${OUT_DIR:-$ANGLE_ROOT/out/Android-arm64-static}"

ANDROID_NDK="${ANDROID_NDK:-${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}}"

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

command -v gn >/dev/null 2>&1 || die "gn not found in PATH"
command -v ninja >/dev/null 2>&1 || die "ninja not found in PATH"
[ -n "$ANDROID_NDK" ] || die \
  "set ANDROID_NDK, ANDROID_NDK_ROOT, or ANDROID_NDK_HOME"
[ -d "$ANDROID_NDK" ] || die "Android NDK not found: $ANDROID_NDK"
[ -f "$ANGLE_ROOT/build/config/BUILDCONFIG.gn" ] || die \
  "ANGLE build dependencies are missing; sync the checkout before building"

mkdir -p "$OUT_DIR"
cd "$ANGLE_ROOT"

# Keep all build settings in the checked-in GN args file.  The NDK path is
# passed separately because it is machine-specific.
gn gen "$OUT_DIR" \
  --args="import(\"//args/android_arm64_static.gn\") android_ndk_root=\"${ANDROID_NDK}\""

ninja -C "$OUT_DIR" angle_static

for library in libEGL.a libGLESv2.a libANGLE.a; do
  [ -f "$OUT_DIR/$library" ] || die "expected archive was not generated: $OUT_DIR/$library"
  printf 'Built %-14s %s bytes\n' "$library" "$(stat -c '%s' "$OUT_DIR/$library")"
done

printf '\nStatic ARM64-v8a ARMv8.0-A output: %s\n' "$OUT_DIR"