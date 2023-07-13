# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(Arras
        VERSION 4.9.0
        LANGUAGES CXX)

set(Building_ArrasCore TRUE)

add_subdirectory(arras4_core)
add_subdirectory(distributed)
if (${BUILD_QT_APPS})
    add_subdirectory(arras_render)
endif()
