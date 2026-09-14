# LTW integration with static ANGLE

The static build exposes the normal EGL and GLES entry points. There is no
`angle_initialize_static()` function and no `dlopen()` step: the linker
resolves ANGLE's symbols from the archives.

```c
#include <angle_static_integration.h>

static void init_angle(void)
{
    // Static ANGLE requires no loader initialization.
    host_eglGetProcAddress = angle_eglGetProcAddress;
}
```

The header aliases `angle_eglGetProcAddress`, `angle_eglGetDisplay`,
`angle_eglInitialize`, and `angle_glGetString` to the standard ANGLE entry
points. It does not define duplicate wrapper symbols.

The final shared LTW library should link:

```cmake
target_link_libraries(ltw_angle
    ${ANGLE_STATIC_DIR}/libEGL.a
    ${ANGLE_STATIC_DIR}/libGLESv2.a
    ${ANGLE_STATIC_DIR}/libANGLE.a
    # Followed by the Vulkan/ANGLE static dependencies required by the
    # generated link graph.
)
```

Keep `-Wl,--gc-sections` only if the LTW export list retains every EGL/GLES
entry point it needs. Static archives are pulled member-by-member, so an
overly aggressive export list can discard entry points that are reached
through `eglGetProcAddress`.

ES 3.2 is already represented by ANGLE's generated GLES 3.2 entry points.
`angle_expose_non_conformant_extensions_and_versions = true` is enabled in the
ARMv8.0-A args file; the integration must not force the reported version by
changing `Display` or `Config` internals.