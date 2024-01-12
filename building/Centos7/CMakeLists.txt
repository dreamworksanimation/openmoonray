# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# These ExternalProject targets can be used to download, build and
# install many of the Moonray dependencies.
# The targets are chained using dependencies so that they run
# serially.

cmake_minimum_required (VERSION 3.23.1)
project(openmoonray_third_party)

include(ExternalProject)

include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
  set(JOBS_ARG -j${N})
endif()

# User configurable settings
set(InstallRoot /usr/local CACHE FILEPATH "Install root for dependencies")
set(PythonVer 3.6 CACHE STRING "Python version (n.m), e.g. 3.6")
set(PythonRoot /usr CACHE FILEPATH "Location of Python install")

set(THIS_DIR ${CMAKE_CURRENT_SOURCE_DIR})

ExternalProject_Add(Blosc
    GIT_REPOSITORY https://github.com/Blosc/c-blosc
    GIT_TAG a44e961498cdca2eb893fa897cd15dd007fad496 # 1.20.1
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
)
set(CHAIN Blosc)

ExternalProject_Add(Boost
    URL https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz
    UPDATE_COMMAND ./bootstrap.sh --prefix=${InstallRoot}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ./b2 install ${JOBS_ARG} --user-config=${THIS_DIR}/python-config.jam --with_python variant=release toolset=gcc link=shared threading=multi
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
    DEPENDS ${CHAIN}
)
set(CHAIN Boost)

ExternalProject_Add(JsonCpp
    GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
    GIT_TAG 5defb4ed1a4293b8e2bf641e16b156fb9de498cc # 1.9.5
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DJSONCPP_LIB_BUILD_SHARED:BOOL=ON
    DEPENDS ${CHAIN}
)
set(CHAIN JsonCpp)

ExternalProject_Add(Lua
    URL https://www.lua.org/ftp/lua-5.3.5.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
# 'make linux' uses the readline library : use 'make generic' to
# avoid this dependency
    BUILD_COMMAND make generic MYCFLAGS=-fPIC MYLIBS=-ldl
    INSTALL_COMMAND cp src/lua src/luac ${InstallRoot}/bin
            COMMAND cp src/lua.h src/luaconf.h src/lualib.h src/lauxlib.h src/lua.hpp ${InstallRoot}/include
            COMMAND cp src/liblua.a ${InstallRoot}/lib
    DEPENDS ${CHAIN}
)
set(CHAIN Lua)

ExternalProject_Add(MicroHttpd
    URL https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.71.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ./configure --prefix ${InstallRoot}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND make install
    DEPENDS ${CHAIN}
)
set(CHAIN MicroHttpd)

ExternalProject_Add(OpenSubdiv
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/OpenSubdiv
    GIT_TAG 8ffa2b6566be10209529d7a0d1db02a0796b160c # v3_5_0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_BUILD_TYPE=Release
      -DNO_PTEX=1 -DNO_OMP=1 -DNO_TBB=1 -DNO_CUDA=1 -DNO_GLFW_X11=1
      -DNO_OPENCL=1 -DNO_CLEW=1 -DNO_REGRESSION=1 -DNO_EXAMPLES=1 -DNO_TUTORIALS=1
    DEPENDS ${CHAIN}
)
set(CHAIN OpenSubdiv)

ExternalProject_Add(OpenEXR
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openexr
    GIT_TAG 8bc3741131db146ad08a5b83af9e6e48f0e94a03 # v2.5.7
    INSTALL_DIR ${InstallRoot}
    PATCH_COMMAND patch IlmBase/Half/CMakeLists.txt ${THIS_DIR}/../Imath_include_paths.patch
    CMAKE_ARGS
        -DBoost_ROOT=<INSTALL_DIR>
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DBUILD_SHARED_LIBS=OFF
    DEPENDS ${CHAIN}
)
set(CHAIN OpenEXR)

ExternalProject_Add(TBB
    URL https://github.com/oneapi-src/oneTBB/archive/2020_U2.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND bash -c "cp build/*_release/libtbb*.* ${InstallRoot}/lib"
            COMMAND bash -c "cp -r include/tbb ${InstallRoot}/include"
    DEPENDS ${CHAIN}
)
set(CHAIN TBB)

ExternalProject_Add(OpenVDB
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openvdb
    GIT_TAG 88ae51a34ca70a23442dc60bba83894f35f7f728 # v8.2.0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DBLOSC_ROOT=/usr
    DEPENDS ${CHAIN}
)
set(CHAIN OpenVDB)

ExternalProject_Add(Log4CPlus
    GIT_REPOSITORY https://github.com/log4cplus/log4cplus
    GIT_TAG bd2dfe9ef0817277a7d41fadecd84addaf943fe3 # REL_1_1_2
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    DEPENDS ${CHAIN}
)
set(CHAIN Log4CPlus)

ExternalProject_Add(CppUnit
    URL http://dev-www.libreoffice.org/src/cppunit-1.15.0.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ./configure --prefix ${InstallRoot}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND make install
    DEPENDS ${CHAIN}
)
set(CHAIN CppUnit)

ExternalProject_Add(Random123
    GIT_REPOSITORY https://github.com/DEShawResearch/random123
    GIT_TAG 726a093cd9a73f3ec3c8d7a70ff10ed8efec8d13 # v1.14.0
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND make install-include prefix=${InstallRoot}
    DEPENDS ${CHAIN}
)
set(CHAIN Random123)

ExternalProject_Add(ISPC
    URL https://github.com/ispc/ispc/releases/download/v1.20.0/ispc-v1.20.0-linux.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cp bin/ispc ${InstallRoot}/bin
    DEPENDS ${CHAIN}
)
set(CHAIN ISPC)

ExternalProject_Add(embree
    GIT_REPOSITORY https://github.com/embree/embree
    GIT_TAG 341ef8c45d1ae072ead1ab65cd76e88b03d9302c # v4.2.0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DEMBREE_ISPC_EXECUTABLE=<INSTALL_DIR>/bin/ispc
        -DEMBREE_ISPC_SUPPORT=ON
        -DEMBREE_TBB_ROOT=<INSTALL_DIR>
        -DEMBREE_IGNORE_INVALID_RAYS=ON
        -DEMBREE_RAY_MASK=ON
        -DEMBREE_MAX_ISA=AVX512
        -DEMBREE_TUTORIALS=OFF
        -DBUILD_SHARED_LIBS=ON
    DEPENDS ${CHAIN}
)
set(CHAIN embree)

ExternalProject_Add(OpenColorIO
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/OpenColorIO
    GIT_TAG 056b7b0cb0d087961e9dba75104820e44faf52a1 # v2.0.2
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DBUILD_SHARED_LIBS=ON
        -DOCIO_BUILD_STATIC=OFF
        -DCMAKE_CXX_STANDARD=17
    DEPENDS ${CHAIN}
)
set(CHAIN OpenColorIO)

ExternalProject_Add(OpenImageIO
    GIT_REPOSITORY https://github.com/OpenImageIO/oiio
    GIT_TAG 331a323468928c8017ad048b26d47c4e57a724a7 # 2.3.20.0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DOpenEXR_ROOT=<INSTALL_DIR>
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DUSE_QT=0
        -DUSE_PYTHON=0
    DEPENDS ${CHAIN}
)
set(CHAIN OpenImageIO)

ExternalProject_Add(OpenImageDenoise
    URL https://github.com/OpenImageDenoise/oidn/releases/download/v2.0.1/oidn-2.0.1.src.tar.gz
    INSTALL_DIR ${InstallRoot}
    PATCH_COMMAND patch devices/cpu/CMakeLists.txt ${THIS_DIR}/oidn_find_tbb.patch
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DISPC_EXECUTABLE=<INSTALL_DIR>/bin/ispc
        -DTBB_ROOT=<INSTALL_DIR>
        -DOIDN_APPS=OFF
    DEPENDS ${CHAIN}
)
set(CHAIN OpenImageDenoise)

ExternalProject_Add(USD
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/USD
    GIT_TAG 3b097e3ba8fabf1777a1256e241ea15df83f3065 # v22.05
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=<INSTALL_DIR>
        -DPXR_ENABLE_PYTHON_SUPPORT=ON
        -DPXR_USE_PYTHON_3=ON
        -DTBB_USE_DEBUG_BUILD=OFF
        -DPXR_BUILD_TESTS=OFF
        -DPXR_BUILD_EXAMPLES=OFF
        -DPXR_BUILD_TUTORIALS=OFF
        -DPXR_BUILD_USD_TOOLS=OFF
        -DPXR_ENABLE_PTEX_SUPPORT=OFF
        -DPXR_ENABLE_OPENVDB_SUPPORT=OFF
        -DPXR_BUILD_USDVIEW=OFF
        -DBoost_NO_BOOST_CMAKE=ON
        -DBoost_NO_SYSTEM_PATHS=ON
        -DTBB_SUPPRESS_DEPRECATED_MESSAGES=1
    DEPENDS ${CHAIN}
)
set(CHAIN USD)

