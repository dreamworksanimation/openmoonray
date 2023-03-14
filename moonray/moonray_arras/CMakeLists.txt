# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(MoonrayArras
        VERSION 10.19
        LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# ================================================
# Find dependencies
# ================================================
find_package(JsonCpp REQUIRED)
find_package(TBB REQUIRED)

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

include(MoonrayArrasCompileDefinitions)
include(MoonrayArrasCompileFeatures)
include(MoonrayArrasCompileOptions)
include(MoonrayArrasLinkOptions)

# ================================================
# Add project files
# ================================================

add_subdirectory(mcrt_messages)
add_subdirectory(mcrt_dataio)
add_subdirectory(mcrt_computation)
