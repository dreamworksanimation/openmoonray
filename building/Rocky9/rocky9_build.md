# Building MoonRay on Rocky Linux 9

The process is very similar to that for Centos 7 : first required packages from Rocky 9 are installed using the ***dnf*** package manager. Then remaining dependencies are built from source using a CMake project in */building/Rocky9*. The final step is the main MoonRay CMake build.

You need a copy of the MoonRay source, and (if you are building with GPU support) the Optix headers. I'll assume these are in */source* and */tmp/optix/include* respectively, although you can place them anywhere. I will use */build* as a build directory : this can also be any directory you choose.

The main difference from the Centos 7 instructions is that the dependency build is set up to install dependencies into their default locations, rather than a */installs* directory. This makes configuration of the final build simpler. This change isn't tied to the use of Rocky 9 -- you can use either approach with either build.

The build can be performed directly on a Rocky 9 system, or in a container. I'll give the instructions for a direct build for simplicity : the Centos 7 container build documentation should show how to apply this to a docker container.

---
## Step 1. Base requirements
---

The script /building/Rocky9/install_packages.sh contains the commands to install required Rocky 9 packages.

```bash
source /source/building/Rocky9/install_packages.sh
```

As with the Centos 7 build, you can remove the Cuda packages if you don't intend to build with GPU support, and the Qt5 packages if you don't want to build the GUI tools.

---
## Step 2. Build the remaining dependencies
---

```
mkdir /build
cd /build
cmake /source/building/Rocky9
cmake --build . -- -j 64
```

"-j 64" is the number of threads to use for parallel building : you can change it if necessary.

Copy the downloaded Optix headers. Since we are placing the dependencies in their default location for this build, they go in */usr/local/include*

```bash
cp -r /tmp/optix/include/* /usr/local/include
```

---
## Step 3. Build MoonRay
---

The Centos 7 build instructions use a CMake preset ("container-release") to configure the main build. CMake configuration is simpler in the Rocky 9 build, because we installed dependencies to their standard locations, and so a preset is not needed (although you can create one if you want...)

```bash
cd /build
rm -rf *
cmake /source -DPYTHON_EXECUTABLE=python3 -DBOOST_PYTHON_COMPONENT_NAME=python39 -DABI_VERSION=0
cmake --build . -j 64
mkdir /installs/openmoonray
cmake --install /build --prefix /installs/openmoonray
```

You can use the options ***-DBUILD_QT_APPS=NO*** and ***-DMOONRAY_USE_CUDA=NO*** in the first CMake command to disable GUI apps and GPU support respectively.

To set up the install and test moonray

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
> moonray_gui -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

---
## Differences from the Centos 7 build
---

More of the dependencies have a suitable version as part of Rocky 9, and so can be installed from there rather than built from source. These are:

***blosc boost lua openvdb tbb log4cplus cppunit libmicrohttpd***

The ***libcgroup*** package installation is not required on Rocky Linux 9 environment.

Python 3.9 and Boost 1.75 come from Rocky 9. This changes a couple of things that were hard-coded into the main CMake build:
- the name of the Python executable is "python3" (it is "python" in the Centos 7 build)
- the name of the Boost Python component is "Boost::python39" (it is "Boost::python" in the Centos 7 build)

As you can see in the main CMake command, these are now settable from the command line.

There are a few very minor changes to the MoonRay source to enable it to compile with GCC 11 and Qt 5.15.3. In addition, the code must be built with C++ ABI version 0, rather than the value 6 used for the Centos 7 build.

---
## Building MoonRay Container with Apptainer and Rocky Linux 9 Image
---

The procedures of building MoonRay container with Apptainer and Rocky Linux 9 image is the following:

1. Clone this repository
2. Copy OptiX install script
3. Build MoonRay container with Apptainer

```bash
git clone -b openmoonray-1.3.0.0 https://github.com/dreamworksanimation/openmoonray.git
cp NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh openmoonray/building
cd openmoonray/building
apptainer build moonray.sif apptainer.def
```

To test MoonRay container

```bash
apptainer run moonray.sif bash
MoonRay> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
MoonRay> moonray_gui -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

To use MoonRay container with NVIDIA GPU

```bash
apptainer run --nv moonray.sif bash
MoonRay> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
MoonRay> moonray_gui -exec_mode xpu -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
```
