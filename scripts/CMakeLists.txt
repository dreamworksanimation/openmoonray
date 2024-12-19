# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

install(FILES setup.sh
    DESTINATION scripts)

install(FILES macOS/setupHoudini.sh
    DESTINATION scripts/macOS)

install(FILES Rocky9/setupHoudini.sh
    DESTINATION scripts/Rocky9)

