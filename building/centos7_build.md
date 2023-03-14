# Building MoonRay on a Centos 7 machine

If there are no conflicts between the base packages that MoonRay requires and packages already installed on the system,
building on a Centos 7 machine is essentially the same as building in a Centos 7 Docker container
(see [container_build.md](container_build.md)).
The process described in this document installs dependencies built from source to the ***/installs*** folder to avoid conflicting with existing installs,
but you can modify the process to install to the default location (usually */usr/local*) if there are no conflicts.

NVIDIA Optix headers need to be downloaded manually from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy), since they require a EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.
The headers are copied into the install area in Step 3.

---
## Step 1. Base requirements
---

These are the Centos 7 packages required by MoonRay and its dependencies. Obviously you can skip any that are already on the system.
This build uses gcc-9 : you may be able to build successfully with other version of GCC.

```bash
> yum install -y epel-release centos-release-scl.noarch
> yum install -y devtoolset-9 devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-libatomic-devel
> yum install -y bison flex  wget git python3 python3-devel patch giflib-devel libmng libtiff-devel libjpeg-devel libatomic libcgroup-devel libuuid-devel openssl-devel curl-devel
> yum install -y yum-utils
> yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
> yum install -y cuda-toolkit-11-4
> yum install -y qt5-qtbase-devel qt5-qtscript-devel
```

You can skip the Qt5 packages if you do not intend to build the MoonRay GUI programs.

CMake-3.23 is required : this is newer than the CMake version in most Linux distributions.

```bash
mkdir /installs
cd /installs
mkdir bin lib include
wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz
tar xzf cmake-3.23.1-linux-x86_64.tar.gz
scl enable devtoolset-9 bash
export PATH=/installs/cmake-3.23.1-linux-x86_64/bin:${PATH}
```

---
## Step 2. Check out the OpenMoonRay source
---

```bash
mkdir /source
cd /source
git clone --recurse-submodules https://github.anim.dreamworks.com/OpenMoonRay/openmoonray.git
cd /
ln -s source/openmoonray/building .
```

---
## Step 3. Build the remaining dependencies
---

Apart from Optix, the remaining MoonRay dependencies can be built from source and installed using CMake.
*CMakeLists.txt* in the *building* directory contains a series of targets that download the sources and
build each dependency. As mentioned above, this installs by default to */installs* : you can modify
CMakeLists.txt as needed if some dependencies are already present, or if you want to install to */usr/local*.
If you change install locations, you may have to create a new CMake preset in step 4.
If you use a different location for Python, or a different version, you will need to edit *python-config.jam*, used by the boost build process.


```bash
mkdir /build
cd /build
cmake ../building
cmake --build . -- -j 64
```

When you run this, the dependencies will be downloaded one-by-one and installed to */installs*.

Next you need to copy the Optix headers into */installs/optix/include*. In this example, they were copied into */tmp/optix.tar* from another machine, using *scp*.

```bash
mkdir /installs/optix
tar kxf /tmp/optix.tar -C /installs/optix
```

---
## Step 4. Build MoonRay
---

If you have installed everything to the locations described in this document, you can use the CMake **container-release** preset to build MoonRay.
Otherwise you may need to create a new preset (usually in *CMakeUserPresets.json*) with the correct locations.
If everything is in its default location, you may not need to specify a preset at all.

```bash
ln -s /source/openmoonray /openmoonray
rm -rf /build/*
cd /openmoonray
cmake --preset container-release
cmake --build --preset container-release -- -j 64
mkdir /installs/openmoonray
cmake --install /build --prefix /installs/openmoonray
```

The configure step will report failure to find Mkl (unless you happen to have it installed). This does not cause a problem : Mkl is only linked into the commands if it was found.

If you are building without Qt, add the argument ***-DBUILD_QT_APPS=NO*** to the first cmake command. 

Set up the install and test moonray

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
> moonray_gui -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```
