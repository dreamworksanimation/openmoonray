---
title: Building MoonRay on Centos 7
---
# Building MoonRay on Centos 7

Start with reading the [general build instructions](../general_build).

This document gives more explicit instructions for building on a Centos 7 machine. All the information here should also be covered in the general document.

To keep it concrete, I've chosen specific directory locations, which you can change as needed:

- */source* location of the openmoonray repository clone
- */build* CMake build directory
- */installs/moonray* location to install MoonRay

To clone the source from the github repo (on the host), use this git command:

```bash
git clone --recurse-submodules https://github.com/dreamworksanimation/openmoonray.git /source
```
You can place the clone anywhere : the rest of this document assumes it is in */source*, so change any reference to */source* to your chosen location.

If you want to include MoonRay GPU support, you will also need to download the NVIDIA Optix headers (from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy)), which require an EULA. Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases. Once you have extracted the download contents, note the location of the header files (under *include*) : these will be copied to */usr/local/include* during the process.

---
## Step 1. Base requirements
---

The first step is to install some additional RPM packages. The script *building/Centos7/install_packages.sh* will install the packages and perform some environment variable setup. 

```bash
source /source/building/Centos7/install_packages.sh
```

You can add arguments `--nocuda` and `--noqt` to skip GPU and GUI support respectively.

---
## Step 2. Build the remaining dependencies
---

The next step is to build the remaining dependencies from source. The CMake project *building/Centos7/CMakeLists.txt* contains targets that will do it automatically.

You need to create a CMake build directory : it can be anywhere, but I will use */build*. The build directory should generally be empty before starting this step, unless you are deliberately performing an incremental rebuild.

```bash
mkdir /build
cd /build
cmake /source/building/Centos7
cmake --build . -- -j $(nproc)
```

The option "-j $(nproc)" tells CMake to use all available cores on your machine for building. You may see a number of warning messages during the build.

If you are building with GPU support, copy the Optix headers that you downloaded and extracted into */usr/local/include*

```bash
> cp -r /tmp/optix/include/* /usr/local/include
```

---
## Step 3. Build MoonRay
---

The main CMake project in *openmoonray* builds MoonRay itself. I will use the same */build* directory as before (though you don't have to), but it must be empty before running cmake.

```bash
cd /build
rm -rf *
export LUA_DIR=/usr/local
cmake /source
cmake --build . -j $(nproc)
```
 
The build is configured to use the version of Lua we installed in step 2, rather than the one in */bin*, by setting ***LUA_DIR*** to */usr/local*.

The install step will install to */installs/openmoonray* : again, this directory is arbitrary, and you can install wherever you like.

```bash
mkdir /installs/openmoonray
cmake --install /build --prefix /installs/openmoonray
```

You can use the options ***-DBUILD_QT_APPS=NO*** and ***-DMOONRAY_USE_CUDA=NO*** in the first CMake command to disable GUI apps and GPU support respectively.

To set up the install and test moonray:

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
> moonray_gui -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
> hd_render -in /source/testdata/sphere.usd -out /tmp/sphere.exr
```

If everything is working, the moonray command should produce output like this:

```
Loading Scene File(s): /source/testdata/rectangle.rdla
Render prep time = 00:00:00.008
  [+] Rendering [======================] 100.0%
00:00:01  671.2 MB | ---------- Time ------------------------------------------
00:00:01  671.2 MB | Render time                      = 00:00:01.404000
00:00:01  671.2 MB | Total time                       = 00:00:01.442000
Wrote /tmp/rectangle.exr
```