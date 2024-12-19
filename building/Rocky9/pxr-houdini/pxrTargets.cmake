# Generated by CMake

# Modified to use the version of USD with headers in $env{PXR_INCLUDE_PREFIX}
# and libs in $env{PXR_LIB_PREFIX}, with dependencies installed to $env{PXR_DEPS_PREFIX}
# $env{PXR_BOOST_PYTHON_LIB} must be set to the location of the boost_python so used by USD
# (Houdini names it libhboost_python39...)

if("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" LESS 2.6)
   message(FATAL_ERROR "CMake >= 2.6.0 required")
endif()
cmake_policy(PUSH)
cmake_policy(VERSION 2.6...3.21)
#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)


set(HPYTHONLIB $ENV{HOUDINI_INSTALL_DIR}/python/lib/libpython3.9${CMAKE_SHARED_LIBRARY_SUFFIX})
SET(HPYTHONINC $ENV{HOUDINI_INSTALL_DIR}/python/include/python3.9)

# Protect against multiple inclusion, which would fail when already imported targets are added once more.
set(_targetsDefined)
set(_targetsNotDefined)
set(_expectedTargets)
foreach(_expectedTarget arch tf gf js trace work plug vt ar kind sdf ndr sdr pcp usd usdGeom usdVol usdMedia usdShade usdLux usdRender usdHydra usdRi usdSkel usdUI usdUtils usdPhysics garch hf hio cameraUtil pxOsd glf hgi hgiGL hgiInterop hd hdSt hdx usdImaging usdImagingGL usdRiImaging usdSkelImaging usdVolImaging usdAppUtils usdviewq)
  list(APPEND _expectedTargets ${_expectedTarget})
  if(NOT TARGET ${_expectedTarget})
    list(APPEND _targetsNotDefined ${_expectedTarget})
  endif()
  if(TARGET ${_expectedTarget})
    list(APPEND _targetsDefined ${_expectedTarget})
  endif()
endforeach()
if("${_targetsDefined}" STREQUAL "${_expectedTargets}")
  unset(_targetsDefined)
  unset(_targetsNotDefined)
  unset(_expectedTargets)
  set(CMAKE_IMPORT_FILE_VERSION)
  cmake_policy(POP)
  return()
endif()
if(NOT "${_targetsDefined}" STREQUAL "")
  message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_targetsDefined}\nTargets not yet defined: ${_targetsNotDefined}\n")
endif()
unset(_targetsDefined)
unset(_targetsNotDefined)
unset(_expectedTargets)


set(_INCLUDE_PREFIX $ENV{PXR_INCLUDE_PREFIX})
set(_LIB_PREFIX $ENV{PXR_LIB_PREFIX})
set(_DEPS_PREFIX $ENV{PXR_DEPS_PREFIX})
set(_BOOST_PYTHON_LIB $ENV{PXR_BOOST_PYTHON_LIB})

# Create imported target arch
add_library(arch SHARED IMPORTED)

set_target_properties(arch PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
#  INTERFACE_LINK_LIBRARIES "dl;/usr/lib64/libm${CMAKE_SHARED_LIBRARY_SUFFIX}"
)

# Create imported target tf
add_library(tf SHARED IMPORTED)

set_target_properties(tf PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX};${HPYTHONINC}"
  INTERFACE_LINK_LIBRARIES "arch;${HPYTHONLIB};${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${HPYTHONINC};${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target gf
add_library(gf SHARED IMPORTED)

set_target_properties(gf PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf"
)

# Create imported target js
add_library(js SHARED IMPORTED)

set_target_properties(js PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target trace
add_library(trace SHARED IMPORTED)

set_target_properties(trace PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;js;tf;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target work
add_library(work SHARED IMPORTED)

set_target_properties(work PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;trace;/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target plug
add_library(plug SHARED IMPORTED)

set_target_properties(plug PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf;js;trace;work;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target vt
add_library(vt SHARED IMPORTED)

set_target_properties(vt PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf;gf;trace;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target ar
add_library(ar SHARED IMPORTED)

set_target_properties(ar PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf;plug;vt;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target kind
add_library(kind SHARED IMPORTED)

set_target_properties(kind PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;plug"
)

# Create imported target sdf
add_library(sdf SHARED IMPORTED)

set_target_properties(sdf PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf;gf;trace;vt;work;ar;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target ndr
add_library(ndr SHARED IMPORTED)

set_target_properties(ndr PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;plug;vt;work;ar;sdf;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target sdr
add_library(sdr SHARED IMPORTED)

set_target_properties(sdr PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;ar;ndr;sdf;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target pcp
add_library(pcp SHARED IMPORTED)

set_target_properties(pcp PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;trace;vt;sdf;work;ar;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target usd
add_library(usd SHARED IMPORTED)

set_target_properties(usd PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;kind;pcp;sdf;ar;plug;tf;trace;vt;work;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target usdGeom
add_library(usdGeom SHARED IMPORTED)

set_target_properties(usdGeom PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "js;tf;plug;vt;sdf;trace;usd;work;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target usdVol
add_library(usdVol SHARED IMPORTED)

set_target_properties(usdVol PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;usd;usdGeom"
)

# Create imported target usdMedia
add_library(usdMedia SHARED IMPORTED)

set_target_properties(usdMedia PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;sdf;usd;usdGeom"
)

# Create imported target usdShade
add_library(usdShade SHARED IMPORTED)

set_target_properties(usdShade PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;sdf;ndr;sdr;usd;usdGeom"
)

# Create imported target usdLux
add_library(usdLux SHARED IMPORTED)

set_target_properties(usdLux PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;ndr;sdf;usd;usdGeom;usdShade"
)

# Create imported target usdRender
add_library(usdRender SHARED IMPORTED)

set_target_properties(usdRender PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "gf;tf;usd;usdGeom"
)

# Create imported target usdHydra
add_library(usdHydra SHARED IMPORTED)

set_target_properties(usdHydra PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;usd;usdShade"
)

# Create imported target usdRi
add_library(usdRi SHARED IMPORTED)

set_target_properties(usdRi PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;sdf;usd;usdShade;usdGeom;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target usdSkel
add_library(usdSkel SHARED IMPORTED)

set_target_properties(usdSkel PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;gf;tf;trace;vt;work;sdf;usd;usdGeom;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target usdUI
add_library(usdUI SHARED IMPORTED)

set_target_properties(usdUI PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;vt;sdf;usd"
)

# Create imported target usdUtils
add_library(usdUtils SHARED IMPORTED)

set_target_properties(usdUtils PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;tf;gf;sdf;usd;usdGeom;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target usdPhysics
add_library(usdPhysics SHARED IMPORTED)

set_target_properties(usdPhysics PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "js;tf;plug;vt;sdf;trace;usd;usdGeom;usdShade;work;${_BOOST_PYTHON_LIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include;${_DEPS_PREFIX}/include"
)

# Create imported target garch
add_library(garch SHARED IMPORTED)

set_target_properties(garch PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
#  INTERFACE_LINK_LIBRARIES "arch;tf;/usr/lib64/libSM${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libICE${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libX11${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libXext${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libGL${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target hf
add_library(hf SHARED IMPORTED)

set_target_properties(hf PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "plug;tf;trace"
)

# Create imported target hio
add_library(hio SHARED IMPORTED)

set_target_properties(hio PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;js;plug;tf;vt;trace;ar;hf"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target cameraUtil
add_library(cameraUtil SHARED IMPORTED)

set_target_properties(cameraUtil PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;gf"
)

# Create imported target pxOsd
add_library(pxOsd SHARED IMPORTED)

set_target_properties(pxOsd PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;gf;vt;${_DEPS_PREFIX}/lib/libosdCPU${CMAKE_SHARED_LIBRARY_SUFFIX};${_DEPS_PREFIX}/lib/libosdGPU${CMAKE_SHARED_LIBRARY_SUFFIX};${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target glf
add_library(glf SHARED IMPORTED)

set_target_properties(glf PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
#  INTERFACE_LINK_LIBRARIES "ar;arch;garch;gf;hf;hio;js;plug;tf;trace;sdf;${_BOOST_PYTHON_LIB};/usr/lib64/libGL${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libSM${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libICE${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libX11${CMAKE_SHARED_LIBRARY_SUFFIX};/usr/lib64/libXext${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target hgi
add_library(hgi SHARED IMPORTED)

set_target_properties(hgi PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "gf;plug;tf"
)

# Create imported target hgiGL
add_library(hgiGL SHARED IMPORTED)

set_target_properties(hgiGL PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "arch;garch;hgi;tf;trace"
)

# Create imported target hgiInterop
add_library(hgiInterop SHARED IMPORTED)

set_target_properties(hgiInterop PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "gf;tf;hgi;vt;garch"
)

# Create imported target hd
add_library(hd SHARED IMPORTED)

set_target_properties(hd PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "plug;tf;trace;vt;work;sdf;cameraUtil;hf;pxOsd;/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target hdSt
add_library(hdSt SHARED IMPORTED)

set_target_properties(hdSt PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "hio;garch;glf;hd;hgiGL;hgiInterop;sdr;tf;trace;${_DEPS_PREFIX}/lib/libosdCPU${CMAKE_SHARED_LIBRARY_SUFFIX};${_DEPS_PREFIX}/lib/libosdGPU${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target hdx
add_library(hdx SHARED IMPORTED)

set_target_properties(hdx PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "plug;tf;vt;gf;work;garch;glf;pxOsd;hd;hdSt;hgi;hgiInterop;cameraUtil;sdf"
)

# Create imported target usdImaging
add_library(usdImaging SHARED IMPORTED)

set_target_properties(usdImaging PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "gf;tf;plug;trace;vt;work;hd;pxOsd;sdf;usd;usdGeom;usdLux;usdShade;usdVol;ar;/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target usdImagingGL
add_library(usdImagingGL SHARED IMPORTED)

set_target_properties(usdImagingGL PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX};${HPYTHONINC}"
  INTERFACE_LINK_LIBRARIES "gf;tf;plug;trace;vt;work;hio;garch;glf;hd;hdx;pxOsd;sdf;sdr;usd;usdGeom;usdHydra;usdShade;usdImaging;ar;${_BOOST_PYTHON_LIB};${HPYTHONLIB};/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${HPYTHONINC};${_DEPS_PREFIX}/include"
)

# Create imported target usdRiImaging
add_library(usdRiImaging SHARED IMPORTED)

set_target_properties(usdRiImaging PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "gf;tf;plug;trace;vt;work;hd;pxOsd;sdf;usd;usdGeom;usdLux;usdShade;usdImaging;usdVol;ar;/usr/lib64/libtbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target usdSkelImaging
add_library(usdSkelImaging SHARED IMPORTED)

set_target_properties(usdSkelImaging PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "hio;hd;usdImaging;usdSkel"
)

# Create imported target usdVolImaging
add_library(usdVolImaging SHARED IMPORTED)

set_target_properties(usdVolImaging PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "usdImaging"
)

# Create imported target usdAppUtils
add_library(usdAppUtils SHARED IMPORTED)

set_target_properties(usdAppUtils PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "garch;gf;hio;sdf;tf;usd;usdGeom;usdImagingGL;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

# Create imported target usdviewq
add_library(usdviewq SHARED IMPORTED)

set_target_properties(usdviewq PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "PXR_PYTHON_ENABLED=1"
  INTERFACE_INCLUDE_DIRECTORIES "${_INCLUDE_PREFIX}"
  INTERFACE_LINK_LIBRARIES "tf;usd;usdGeom;${_BOOST_PYTHON_LIB}"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${_DEPS_PREFIX}/include"
)

if(CMAKE_VERSION VERSION_LESS 2.8.12)
  message(FATAL_ERROR "This file relies on consumers using CMake 2.8.12 or greater.")
endif()

# Load information for each installed configuration.
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/pxrTargets-*.cmake")
foreach(f ${CONFIG_FILES})
  include(${f})
endforeach()

# Cleanup temporary variables.
set(_IMPORT_PREFIX)

# Loop over all imported files and verify that they actually exist
foreach(target ${_IMPORT_CHECK_TARGETS} )
  foreach(file ${_IMPORT_CHECK_FILES_FOR_${target}} )
    if(NOT EXISTS "${file}" )
      message(FATAL_ERROR "The imported target \"${target}\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
  endforeach()
  unset(_IMPORT_CHECK_FILES_FOR_${target})
endforeach()
unset(_IMPORT_CHECK_TARGETS)

# This file does not depend on other imported targets which have
# been exported from the same project but in a separate export set.

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
cmake_policy(POP)
