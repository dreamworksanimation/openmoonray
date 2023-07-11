# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# These ExternalProject targets can be used to download, build and
# install many of the Moonray dependencies.
# The targets are chained using dependencies so that they run
# serially.

cmake_minimum_required (VERSION 3.23.1)
project(openmoonray_third_party)

include(ExternalProject)

set(THIS_DIR ${CMAKE_CURRENT_SOURCE_DIR})

ExternalProject_Add(JsonCpp
    GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
    GIT_TAG ba3fd412929ec4822788b401298e8d9e4950cbab # 0.10.7  
    CMAKE_ARGS
        -DBUILD_SHARED_LIBS=1
        -DPYTHON_EXECUTABLE=/usr/bin/python3
        -DJSONCPP_LIB_BUILD_SHARED:BOOL=ON
)
set(CHAIN JsonCpp)

ExternalProject_Add(OpenSubdiv
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/OpenSubdiv
    GIT_TAG 82ab1b9f54c87fdd7e989a3470d53e137b8ca270 # v3_4_3
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE=Release
      -DPYTHON_EXECUTABLE=/usr/bin/python3
      -DNO_PTEX=1 -DNO_OMP=1 -DNO_TBB=1 -DNO_CUDA=1 -DNO_GLFW_X11=1 -DNO_DOC=1
      -DNO_OPENCL=1 -DNO_CLEW=1 -DNO_REGRESSION=1 -DNO_EXAMPLES=1 -DNO_TUTORIALS=1 -DNO_GLTESTS=1 
      -DNO_MACOS_FRAMEWORK=1 -DNO_METAL=1 -DNO_TESTS=1 
    DEPENDS ${CHAIN}
)
set(CHAIN OpenSubdiv)

ExternalProject_Add(OpenEXR
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openexr
    GIT_TAG 8bc3741131db146ad08a5b83af9e6e48f0e94a03 # v2.5.7
    CMAKE_ARGS
        -DBUILD_SHARED_LIBS=OFF
    DEPENDS ${CHAIN}
)
set(CHAIN OpenEXR)

ExternalProject_Add(Random123
    GIT_REPOSITORY https://github.com/DEShawResearch/random123
    GIT_TAG 726a093cd9a73f3ec3c8d7a70ff10ed8efec8d13 # v1.14.0
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND make install-include
    DEPENDS ${CHAIN}
)
set(CHAIN Random123)

ExternalProject_Add(ISPC
    # URL https://github.com/ispc/ispc/releases/download/v1.14.1/ispc-v1.14.1-linux.tar.gz
    URL https://github.com/ispc/ispc/releases/download/v1.20.0/ispc-v1.20.0-linux.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cp bin/ispc /usr/local/bin
    DEPENDS ${CHAIN}
)
set(CHAIN ISPC)

ExternalProject_Add(embree
    GIT_REPOSITORY https://github.com/embree/embree
    # GIT_TAG 69bd4c272f1ed608494f233ecfff3feec516880b # v3.12.1
    GIT_TAG 698442324ccddd11725fb8875275dc1384f7fb40 # v3.13.5
    PATCH_COMMAND patch -p1 < ${THIS_DIR}/embree_missing_type.patch
    CMAKE_ARGS 
        -DEMBREE_ISPC_EXECUTABLE=/usr/local/bin/ispc
        -DEMBREE_IGNORE_INVALID_RAYS=ON
        -DEMBREE_RAY_MASK=ON
        -DEMBREE_MAX_ISA=AVX
        -DEMBREE_TUTORIALS=OFF
        -DBUILD_SHARED_LIBS=ON
    DEPENDS ${CHAIN}
)
set(CHAIN embree)

ExternalProject_Add(OpenColorIO
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/OpenColorIO
    GIT_TAG 056b7b0cb0d087961e9dba75104820e44faf52a1 # v2.0.2
    CMAKE_ARGS
        -DBUILD_SHARED_LIBS=ON
        -DOCIO_BUILD_STATIC=OFF
        -DCMAKE_CXX_STANDARD=17
    DEPENDS ${CHAIN}
)
set(CHAIN OpenColorIO)

ExternalProject_Add(OpenImageIO
    GIT_REPOSITORY https://github.com/OpenImageIO/oiio
    GIT_TAG 331a323468928c8017ad048b26d47c4e57a724a7 # 2.3.10.0
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
        -DUSE_QT=0
        -DUSE_PYTHON=0
    DEPENDS ${CHAIN}
)
set(CHAIN OpenImageIO)

ExternalProject_Add(OpenImageDenoise
    URL https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.3/oidn-1.4.3.src.tar.gz
    # GIT_REPOSITORY https://github.com/OpenImageDenoise/oidn
    # GIT_TAG d959bac5b7130b31c41095811ddfbe58c4cf03f4 # 1.4.3
    CMAKE_ARGS
        -DISPC_EXECUTABLE=/usr/local/bin/ispc
        -DOIDN_APPS=OFF
    DEPENDS ${CHAIN}
)
set(CHAIN OpenImageDenoise)

ExternalProject_Add(USD
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/USD
    # GIT_TAG 7a5f8c4311fed3ef2271d5e4b51025fb0f513730 # v21.08
    # GIT_TAG 3b097e3ba8fabf1777a1256e241ea15df83f3065 # v22.05
    GIT_TAG 0c7b9a95f155c221ff7df9270a39a52e3b23af8b # v22.11
    CMAKE_ARGS
        -DPXR_ENABLE_PYTHON_SUPPORT=ON
        -DPXR_USE_PYTHON_3=ON
        -DPYTHON_LIBRARIES=/usr/lib64 
        -DPYTHON_INCLUDE_DIRS=/usr/include
        -DBoost_NO_BOOST_CMAKE=ON 
        -DBoost_NO_SYSTEM_PATHS=ON
        -DBoost_LIBRARY_DIR=/usr/lib64 
        -DBoost_INCLUDE_DIR=/usr/include  
        -DTBB_USE_DEBUG_BUILD=OFF
        -DTBB_ROOT_DIR=/usr 
        -DTBB_LIBRARIES=/usr/lib64 
        -DTBB_INCLUDE_DIRS=/usr/include ..
        -DPXR_BUILD_TESTS=OFF
        -DPXR_BUILD_EXAMPLES=OFF
        -DPXR_BUILD_TUTORIALS=OFF
        -DPXR_BUILD_USD_TOOLS=OFF
        -DPXR_ENABLE_PTEX_SUPPORT=OFF
        -DPXR_ENABLE_OPENVDB_SUPPORT=OFF
        -DPXR_BUILD_USDVIEW=OFF
             
    DEPENDS ${CHAIN}
)
set(CHAIN USD)
