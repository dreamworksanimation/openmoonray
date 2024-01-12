# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(ArrasDistributed
        VERSION 4.9.0
        LANGUAGES CXX)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../../release)
# set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)

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
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_INSTALL_PREFIX}/cmake")
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

# TODO: Review these, and add them where appropriate
# These options are used in our SCons builds at the top-level,
# but that doesn't seem like good practice to repeat here. Each
# library/executable should probably set have its own required
# target_compile_options. For now, disabling all of these
#[[
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(
        PUBLIC
            -Wno-narrowing       # W: Conversion int to short int may alter value
            -Wno-conversion      # W: Conversion between datatypes may alter value
            -Wno-switch          # W: Not all possible cases are explicitly handled
            -Wno-unknown-pragmas # W: Don't yell at me about pragmas
            -Wno-unused-variable # W: Don't yell at me about unused variables
            -Wno-sign-compare    # W: Sign vs. Unsigned comparisons
            -fabi-version=6      # O: Application Binary Interface to version 6
            -Wno-unused-local-typedefs # W: Locally defined typedef but not used
            -Wno-class-memaccess # W: with no trivial copy-assignment
            -Wno-maybe-uninitialized # W: may be used uninitialized in this function
            -Wno-cast-function-type # W: cast between incompatible function types
            -fno-var-tracking-assignments # W: Turn off variable tracking
            -mavx  # O: Enable AVX
            -mfma # O: Enable FMA
            -ffast-math # O: Fast Math
            -msse)
endif()
#]]

# ================================================
# Add project files
# ================================================

add_subdirectory(arras4_node)
add_subdirectory(minicoord)
add_subdirectory(scripts)

