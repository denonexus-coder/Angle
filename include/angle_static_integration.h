#ifndef ANGLE_STATIC_INTEGRATION_H_
#define ANGLE_STATIC_INTEGRATION_H_

// Static ANGLE has no loader-library initialization step.  Link the archives
// and use the normal EGL/GLES entry points directly.
#include <EGL/egl.h>
#include <GLES2/gl2.h>

// These aliases let an embedder keep a separate "static ANGLE" dispatch name
// without introducing wrapper functions or duplicate symbol definitions.
#define angle_eglGetProcAddress eglGetProcAddress
#define angle_eglGetDisplay eglGetDisplay
#define angle_eglInitialize eglInitialize
#define angle_glGetString glGetString

#endif  // ANGLE_STATIC_INTEGRATION_H_