---
title: Building MoonRay in a Centos 7 Docker container
---
# Building MoonRay in a Centos 7 Docker container

Start with reading the [general build instructions](../general_build).

This document follows essentially the same process as building directly on a Centos 7 system, but inside a container.

To keep it concrete, I've chosen specific directory locations inside the container : you can change these if needed:

- */source* location of the openmoonray repository clone
- */build* CMake build directory
- */installs/moonray* location to install MoonRay

You will need Docker and a copy of the MoonRay source. To clone the source from the github repo (on the host), use this git command:

```bash
> git clone --recurse-submodules https://github.com/dreamworksanimation/openmoonray.git 
```
You can place the clone anywhere : the rest of this document calls the directory you have cloned openmoonray into (on the host machine) ***openmoonray-dir***. It will be mounted at */source* inside the container.

This version of the build omits Cuda/GPU support, because GPU devices are not generally available inside a container. See the general build documentation for how to add GPU support.

---
## Step 1. Base requirements
---

Start a new container running the centos:7 image:

```bash
> docker run -v <openmoonray-dir>:/source -v /tmp:/tmp --rm -it centos:7
```

Once inside the container, the first step is to install some additional RPM packages. The script *building/Centos7/install_packages.sh* will install the packages and perform some environment variable setup. 

```bash
source /source/building/Centos7/install_packages.sh --nocuda
```

---
## Step 2. Build the remaining dependencies
---

The next step is to build the remaining dependencies from source. The CMake project *building/Centos7/CMakeLists.txt* contains targets that will do it automatically.

```bash
> mkdir /build
> cd /build
> cmake /source/building/Centos7
> cmake --build . -- -j $(nproc)
```

The option "-j $(nproc)" tells CMake to use all available cores on your machine for building.

---
## Step 3. Build MoonRay
---

The main CMake project in *openmoonray* builds MoonRay itself, and installs it to a specified location.

```bash
> cd /build
> rm -rf *
> export LUA_DIR=/usr/local
> cmake /source -DMOONRAY_USE_CUDA=NO
> cmake --build . -j $(nproc)

> mkdir /installs/openmoonray
> cmake --install /build --prefix /installs/openmoonray
```

Set up the install and test moonray:

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
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

Note: when running hd_render or other tools, you may see an error like this:

**hd_render: symbol lookup error: /usr/local/lib/libusd_usdGeom.so: undefined symbol: _ZdaPvm**

This can occur because devtoolset-9 contains a conflicting version of the TBB library (libtbb.so.2) in /opt/rh/devtoolset-9/root/usr/lib64/dyninst. To fix the error, either modify LD_LIBRARY_PATH to remove the "dyninst" directories, or simply type "exit" to leave the devtoolset-9 environment (then source setup.sh again).

---
## Step 4 : Commit container
---

To reduce the container size, you may want to delete all the files in */build* before saving the container : they are no longer needed.

To save the container as an image, run 'docker ps` in another shell. This will show you the running container ID. Then you can use "docker commit" to save the container out to a new *openmoonray* Docker image:

```bash
> docker ps

CONTAINER ID        IMAGE               ...
c3a90b08a53a        centos:7            ...

> docker commit c3a90b08a53a openmoonray
```

The container ID will be different in your case. Do not exit the shell that is running the container until the commit command completes.

To run the new container:

```bash
> docker run -v <openmoonray-dir>:/source -v /tmp:/tmp --rm -it openmoonray
```

Moonray doesn't need the source repository mounted to run, but it is included here to provide access to the test files. You can add any additional mounts you need to access files on the host machine.

You will need to rerun *setup.sh* once the container is started, to set up the environment:

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

---
## Running moonray_gui
---

To run **moonray_gui**, you need to set up X in the container. The steps required may vary depending on the host setup, but generally you will need to set the environment variables ***DISPLAY*** and ***XAUTHORITY***, and make sure the directory that *XAUTHORITY* points to is mounted in the container. 

At least on my machine, it is also necessary to install an updated version of systemd, (otherwise a crash occurs in libdbus) and libxkbcommon-xll (or the hotkeys don't work). For reference, these are the version that are installed:

- systemd-219-78.el7_9.7.x86_64.rpm (vs 219-78.el7)
- libxkbcommon-x11-0.7.1-3.el7.x86_64.rpm


```bash
> docker run -v <openmoonray-dir>:/source -v /tmp:/tmp -e DISPLAY=$DISPLAY -e XAUTHORITY=${XAUTHORITY} -v "${XAUTHORITY}:${XAUTHORITY}:z" --rm -it openmoonray
> yum install -y libxkbcommon-x11
> yum install -y systemd
> source /installs/openmoonray/scripts/setup.sh
> moonray_gui -in /source/testdata/rectangle.rdla -out /tmp/rectangle.exr
```
