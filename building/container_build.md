# Building MoonRay in a Docker container

You will need Docker and a copy of the MoonRay source. The instructions assume that the source is in */source/openmoonray*

NVIDIA Optix headers need to be downloaded manually from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy), since they require a EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.
The instructions assume that these are in */optix/include*. 

Substitute */source/openmoonray* and */optix* for the actual locations wherever they appear in the instructions.

---
## Step 1. Base requirements
---

The base image for building MoonRay in a container is constructed using *Dockerfile* in the *building* directory of the MoonRay source. It contains a number of MoonRay dependencies that are installed using *yum*, the Centos-7 package manager. It also intalls CMake, needed for Step 2.

You can remove the Qt5 packages from the Dockerfile if you do not intend to build the MoonRay GUI programs.

```bash
> cd /source/openmoonray/building
> docker build -t openmoonray_base . --file Dockerfile
```

---
## Step 2. Build the remaining dependencies
---

Apart from Optix, the remaining MoonRay dependencies can be built from source and installed using CMake. *CMakeLists.txt* in the *building* directory contains a series of targets that download the sources and build each dependency. 


Start the base container from step 1.

```bash
> docker run -v /source/openmoonray/building:/building:shared  -v /optix:/optix:shared --network=host --rm -it openmoonray_base
```

Run the CMake external projects build. The targets are set up to build one at a time. The build takes about 20 minutes on my machine.

```bash
> cd /build
> cmake ../building
> cmake --build . -- -j 64
```

Clean up the build residue, and copy the Optix headers into */installs*

```bash
> rm -rf /build/*
> mkdir /installs/optix
> cp -r /optix/include /installs/optix
```

The dependencies required to build openmoonray are now installed into the container.

To avoid re-running this step, commit the image as **openmoonray_build**. In another shell:

```bash
> docker ps

CONTAINER ID        IMAGE               ...
c3a90b08a53a        openmoonray_base    ...

> docker commit c3a90b08a53a openmoonray_build
```

You can then exit the container.

---
## Step 3. Build MoonRay
---

The entire OpenMoonRay code base is built by running CMake at the top level of the source tree. The locations of dependencies are provided to the build system using a CMake preset defined in *CMakePresets.json*. The source tree already contains a preset for building in a container created following the process described here, called **container-release**.

To continue the container build process, run the **openmoonray_build** container with the OpenMoonRay source mounted. 

```bash
> docker run -v /source/openmoonray:/openmoonray:shared -v /tmp:/tmp:shared --network=host --rm -it openmoonray_build
```

cd to the root of the source and build openmoonray:

```bash
> cd /openmoonray
> cmake --preset container-release 
> cmake --build --preset container-release -- -j 64
> mkdir /installs/openmoonray
> cmake --install ../build --prefix /installs/openmoonray
```
The configure step will report failure to find Mkl (unless you happen to have it installed). This does not cause a problem : Mkl is only linked into the commands if it was found.

If you are building without Qt, add the argument ***-DBUILD_QT_APPS=NO*** to the first cmake command. 

Set up the install and test moonray

```bash
> source /installs/openmoonray/scripts/setup.sh
> moonray -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

To commit **openmoonray_run**, follow the same procedure as step 2.

---

## 4. Running moonray_gui 
---

To run **moonray_gui**, you need to set up X in the container. The steps required may vary depending on the host setup, but generally you will need to set the environment variables ***DISPLAY*** and ***XAUTHORITY***, and make sure the directory that *XAUTHORITY* points to is mounted in the container. 

You may also need to install additional packages. On my machine, the hotkeys in moonray_gui do not function if package *libxkbcommon-x11* is not installed.

```bash
> docker run -v /source/openmoonray:/openmoonray:shared -v /tmp:/tmp:shared -e DISPLAY=$DISPLAY -e XAUTHORITY=${XAUTHORITY} -v "${XAUTHORITY}:${XAUTHORITY}:z" --network=host --rm -it openmoonray_run

> yum install -y libxkbcommon-x11
> source /installs/openmoonray/scripts/setup.sh
> moonray_gui -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```
