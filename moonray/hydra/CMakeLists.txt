# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(HdMoonray
    VERSION 0.21.19.0
    LANGUAGES CXX C
)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# ================================================
# Options
# ================================================

# ================================================
# Find dependencies
# ================================================
if(NOT IsDarwinPlatform)
    find_package(Python3 REQUIRED COMPONENTS Development)
endif()

# boost
# TODO: setting this/these should not be necessary before calling find_package.
# see: https://stackoverflow.com/questions/55217771/boostcmake-no-suitable-build-variant
set(BUILD_SHARED_LIBS ON)
if(NOT IsDarwinPlatform)
    find_package(Boost REQUIRED COMPONENTS python)
endif()

# the DWA installation of pxrConfig.cmake lives in
# the usd_imaging Rez package. To work correctly, it
# requires env vars REZ_USD_CORE_ROOT, REZ_USD_IMAGING_ROOT
# and PXR_INCLUDE_DIRS to be set (e.g. in CMake preset).
# A standard installation should not require these...
if(NOT pxr_FOUND)
    find_package(pxr REQUIRED)
endif()

find_package(JPEG REQUIRED)
find_package(OpenImageIO REQUIRED)
find_package(TBB REQUIRED)

# Set the RPATH for binaries in the install tree
set(CMAKE_INSTALL_RPATH ${GLOBAL_INSTALL_RPATH})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# ================================================
# Add compile options for all subdirectories
# ================================================
# If the user does not specify CMAKE_BUILD_TYPE on the command-line,
# default to Release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

include(HdMoonrayCompileDefinitions)
include(HdMoonrayCompileFeatures)
include(HdMoonrayCompileOptions)
#include(HdMoonrayLinkOptions) # TODO: Clean this!

# ================================================
# Add project files
# ================================================
add_subdirectory(hdMoonray)
add_subdirectory(moonray_sdr_plugins)

# ================================================
# Install
# ================================================
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# install main plugInfo
INSTALL(FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/plugInfo.json
        DESTINATION
            plugin/usd
)

# This will be used to replace @PACKAGE_cmakeModulesDir@
set(cmakeModulesDir cmake)

configure_package_config_file(
    ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION
        ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}
    PATH_VARS cmakeModulesDir
    # NO_SET_AND_CHECK_MACRO
    # NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
    ${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMinorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION
        ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}
    # COMPONENT ...
)
