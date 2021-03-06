if(CYASSL_PREFER_STATIC_LIB)
    set(CYASSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(WIN32)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a .lib ${CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
endif()

if(UNIX)
  find_package(PkgConfig QUIET)
  pkg_check_modules(_CYASSL QUIET cyassl)
endif()

find_path(CYASSL_INCLUDE_DIR NAMES cyassl/version.h HINTS ${_CYASSL_INCLUDEDIR})
find_library(CYASSL_LIBRARY NAMES cyassl HINTS ${_CYASSL_LIBDIR})

if(CYASSL_INCLUDE_DIR)
    if(_CYASSL_VERSION)
        set(CYASSL_VERSION ${_CYASSL_VERSION})
    else()
        file(STRINGS "${CYASSL_INCLUDE_DIR}/cyassl/version.h" CYASSL_VERSION_STR REGEX "^#define[\t ]+LIBCYASSL_VERSION_STRING[\t ]+\"[^\"]+\"")
        if(CYASSL_VERSION_STR MATCHES "\"([^\"]+)\"")
            set(CYASSL_VERSION "${CMAKE_MATCH_1}")
        endif()
    endif()
endif()

set(CYASSL_INCLUDE_DIRS ${CYASSL_INCLUDE_DIR})
set(CYASSL_LIBRARIES ${CYASSL_LIBRARY})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(CyaSSL
    REQUIRED_VARS
        CYASSL_LIBRARY
        CYASSL_INCLUDE_DIR
    VERSION_VAR
        CYASSL_VERSION
)

mark_as_advanced(CYASSL_INCLUDE_DIR CYASSL_LIBRARY)

if(CYASSL_PREFER_STATIC_LIB)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CYASSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    unset(CYASSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES)
endif()
