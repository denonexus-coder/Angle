# Android ARM64-v8a static build

This checkout builds a Vulkan-only static ANGLE for the **ARMv8.0-A
baseline**. `arm64-v8a` describes the Android ABI; it does not mean ARMv8.1
or newer. The GN configuration emits `-march=armv8-a` and never uses
`-mcpu=native`.

The Android API level is fixed at **26** in this configuration. It is separate
from the ARM instruction-set baseline.

## Dependencies

The ANGLE checkout must have its Chromium/ANGLE dependencies synchronized,
including the GN build files, Vulkan headers, Vulkan loader, SPIR-V tools,
Abseil, zlib, and the Android toolchain. An NDK with an AArch64 Clang toolchain
is required.

## Build

```bash
export ANDROID_NDK=/path/to/android-ndk
./scripts/build_android_static.sh
```

The output directory is `out/Android-arm64-static/`. The requested targets
are:

```text
libEGL.a
libGLESv2.a
libANGLE.a
```

`angle_static` also builds the Vulkan backend and its transitive static
dependencies. When linking outside GN, preserve the dependency order shown by
the generated Ninja link metadata; a static archive does not carry a dynamic
dependency table.

## Reset generated output

```bash
./scripts/clean_build.sh
```

This removes only the generated Android output directories. It does not remove
the tracked `.gn` file or source files.

## ARMv8.0 validation

For shared-library output, the existing validator can be run with:

```bash
./tools/check_armv80.sh out/Android-arm64-v8
```

For static archives, inspect the archive members with the NDK LLVM tools after
the build. The compile command lines must contain `-march=armv8-a`, and must
not contain `-mcpu=native`, `-march=armv8.1-a`, or a newer architecture.