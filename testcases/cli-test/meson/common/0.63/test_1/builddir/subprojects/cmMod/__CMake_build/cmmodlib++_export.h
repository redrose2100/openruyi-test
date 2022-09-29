
#ifndef CMMODLIB___EXPORT_H
#define CMMODLIB___EXPORT_H

#ifdef CMMODLIB___STATIC_DEFINE
#  define CMMODLIB___EXPORT
#  define CMMODLIB___NO_EXPORT
#else
#  ifndef CMMODLIB___EXPORT
#    ifdef cmModLib___EXPORTS
        /* We are building this library */
#      define CMMODLIB___EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define CMMODLIB___EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef CMMODLIB___NO_EXPORT
#    define CMMODLIB___NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef CMMODLIB___DEPRECATED
#  define CMMODLIB___DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef CMMODLIB___DEPRECATED_EXPORT
#  define CMMODLIB___DEPRECATED_EXPORT CMMODLIB___EXPORT CMMODLIB___DEPRECATED
#endif

#ifndef CMMODLIB___DEPRECATED_NO_EXPORT
#  define CMMODLIB___DEPRECATED_NO_EXPORT CMMODLIB___NO_EXPORT CMMODLIB___DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef CMMODLIB___NO_DEPRECATED
#    define CMMODLIB___NO_DEPRECATED
#  endif
#endif

#endif /* CMMODLIB___EXPORT_H */
