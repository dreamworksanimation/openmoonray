# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(Arras
        VERSION 4.9.0
        LANGUAGES CXX)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../release)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(Building_ArrasCore TRUE)

add_subdirectory(arras4_core)
add_subdirectory(distributed)
if (${BUILD_QT_APPS})
    add_subdirectory(arras_render)
endif()
