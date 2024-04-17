# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(ArrasDistributed
        VERSION 4.9.0
        LANGUAGES CXX)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../../release)

# ================================================
# Find dependencies
# ================================================
# TODO: setting this/these should not be necessary before calling find_package.
# see: https://stackoverflow.com/questions/55217771/boostcmake-no-suitable-build-variant
set(BUILD_SHARED_LIBS ON)
find_package(Boost REQUIRED
        COMPONENTS
            chrono
            date_time
            filesystem
            program_options
            system)

# if we aren't building ArrasCore, get it from the release
if (NOT Building_ArrasCore)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake)
    find_package(ArrasCore REQUIRED)
endif()

# ================================================
# Set the RPATH for binaries in the install tree
# ================================================
set(CMAKE_INSTALL_RPATH $ORIGIN $ORIGIN/../lib64)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# ================================================
# Add compile options for all subdirectories
# ================================================
# If the user does not specify CMAKE_BUILD_TYPE on the command-line,
# default to Release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Set optimization level for Debug builds to -O0
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")

# ================================================
# Add project files
# ================================================
add_subdirectory(arras4_node)
add_subdirectory(minicoord)
add_subdirectory(scripts)

