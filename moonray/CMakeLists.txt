# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_subdirectory(hydra)
add_subdirectory(mcrt_denoise)
add_subdirectory(moonray)
add_subdirectory(moonray_arras)
add_subdirectory(moonray_dcc_plugins)
add_subdirectory(moonshine)
add_subdirectory(moonshine_usd)
add_subdirectory(render_profile_viewer)
add_subdirectory(scene_rdl2)

if (${BUILD_QT_APPS})
    add_subdirectory(moonray_gui)
endif()
