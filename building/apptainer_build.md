# Building MoonRay using Apptainer (formerly Singularity)

You will need [Apptainer (formerly Singularity)](https://github.com/apptainer/apptainer) and a copy of the MoonRay source.

Apptainer installation on Rocky Linux 8 and 9 is as simple as the following, detail explanation is [here](https://apptainer.org/docs/admin/main/installation.html#install-rpm-from-epel-or-fedora).

```bash
> sudo dnf install epel-release
> sudo dnf install -y apptainer
```

Apptainer installation on Ubuntu 20.04 and 22.04 is as simple as the following, detail explanation is [here](https://apptainer.org/docs/admin/main/installation.html#install-ubuntu-packages). 

```bash
> sudo add-apt-repository -y ppa:apptainer/ppa
> sudo apt update
> sudo apt install -y apptainer
```

NVIDIA Optix headers need to be downloaded manually from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy), since they require a EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.
The instructions assume `NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh` is located under `openmoonray/building` directory as same as this document. 



---
## Step 1. Base requirements
---

The base image for building MoonRay in a container is constructed using *moonray-rocky9-base.def* in the *building* directory of the MoonRay source. It contains a number of MoonRay dependencies that are installed using *dnf*, the Rocky Linux 9 package manager. It also intalls CMake, needed for Step 2.

* clone MoonRay repo

```bash
> cd ~/
> git clone https://github.com/dreamworksanimation/openmoonray.git
```

* Create cache and tmp directory for Apptaienr. This step is optional but recommended for building large contaienr.

```bash
> mkdir ~/{.cache,.tmp}
> export CACHEDIR=~/.cache
> export TMPDIR=~/.tmp 
```

* Build base image

```bash
> cd openmoonray/building
> apptainer build moonray-rocky9-base.sif moonray-rocky9-base.def
```

---
## Step 2. Build the remaining dependencies
---

Apart from Optix, the remaining MoonRay dependencies can be built from source and installed using CMake. *CMakeLists.txt* in the *building* directory contains a series of targets that download the sources and build each dependency.

```bash
> apptainer build moonray-rocky9-depbuild.sif moonray-rocky9-depbuild.def
```

---
## Step 3. Build MoonRay
---

The entire OpenMoonRay code base is built by running CMake at the top level of the source tree. The locations of dependencies are provided to the build system using a CMake preset defined in *CMakePresets.json*. The source tree already contains a preset for building in a container created following the process described here, called **container-release**.

* Building with Qt

```bash
> apptainer build moonray-rocky9.sif moonray-rocky9.def
```

* Building without Qt

```bash
> apptainer build moonray-rocky9.sif moonray-rocky9-withoutQt.def
```

* Test moonray

```bash
> apptainer shell --writable-tmpfs moonray-rocky9.sif
source /installs/openmoonray/scripts/setup.sh
MoonRay> source /installs/openmoonray/scripts/setup.sh
MoonRay> moonray -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

---
## 4. Running moonray_gui 
---

```bash
> apptainer shell --writable-tmpfs moonray-rocky9.sif
source /installs/openmoonray/scripts/setup.sh
MoonRay> source /installs/openmoonray/scripts/setup.sh
MoonRay> moonray_gui -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

---
## 5. Portability of Apptainer (formerly Singularity) container
---

Once successfully built `moonray-rocky9.sif`, just copy this file to other Apptainer installed system (ex. Rocky Linux 8/9, Ubuntu 20.04/22.04, Windows10/11 WSL2 Ubuntu) normally works.

```bash
> scp moonray-rocky9.sif ciq@moonray:/home/ciq
> ssh ciq@moonray
> [ciq@moonray]$ apptainer shell --writable-tmpfs moonray-rocky9.sif
source /installs/openmoonray/scripts/setup.sh
MoonRay> source /installs/openmoonray/scripts/setup.sh
MoonRay> moonray_gui -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

Reference: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0177459
> Singularity: Scientific containers for mobility of compute
> Gregory M. Kurtzer, Vanessa Sochat, Michael W. Bauer
> Published: May 11, 2017
> https://doi.org/10.1371/journal.pone.0177459
