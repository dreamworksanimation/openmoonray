# Building MoonRay using Apptainer (formerly Singularity)

You will need [Apptainer (formerly Singularity)](https://github.com/apptainer/apptainer) and a copy of the MoonRay source.

Apptainer installation on Rocky Linux 8 and 9 is as simple as the following, detail explanation is [here](https://apptainer.org/docs/admin/main/installation.html#install-rpm-from-epel-or-fedora).

```bash
> sudo dnf install -y epel-release
> sudo dnf install -y apptainer
```

Apptainer installation on Ubuntu 20.04 and 22.04 is as simple as the following, detail explanation is [here](https://apptainer.org/docs/admin/main/installation.html#install-ubuntu-packages). 

```bash
> sudo add-apt-repository -y ppa:apptainer/ppa
> sudo apt install -y apptainer
```

NVIDIA Optix headers need to be downloaded manually from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy), since they require a EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.

---
## 1. Build MoonRay
---

* Clone MoonRay repo

```bash
> git clone --recurse-submodules https://github.com/dreamworksanimation/openmoonray.git
```

* Copy NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh

The instructions assume `NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh` is located under `~/Downloads` directory. 

```bash
> cp ~/Downloads/NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh .
```

* Build MoonRay using Apptainer via helper script called `moonray.sh`

```bash
> export WORKDIR=$(pwd)
> bash ./openmoonray/building/apptainer/moonray.sh
```

---
## 2. Running MoonRay
---

* Test moonray

```bash
> cd $WORKDIR/openmoonray/building/apptainer
> apptainer shell moonray-rocky9.sif
MoonRay> moonray -in $WORKDIR/openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

* Test moonray_gui

```bash
> cd $WORKDIR/openmoonray/building/apptainer
> apptainer shell moonray-rocky9.sif
MoonRay> moonray_gui -in $WORKDIR/openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

---
## 3. Portability of Apptainer (formerly Singularity) container
---

Once successfully built `moonray-rocky9.sif`, just copy this file to other Apptainer installed system (ex. Rocky Linux 8/9, Ubuntu 20.04/22.04, Windows10/11 WSL2 Ubuntu) normally works.

```bash
> scp moonray-rocky9.sif ciq@moonray:/home/ciq
> ssh ciq@moonray
> [ciq@moonray]$ git clone https://github.com/dreamworksanimation/openmoonray.git #to get testdata
> [ciq@moonray]$ apptainer shell moonray-rocky9.sif
MoonRay> moonray_gui -in ~/openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr
```

Reference: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0177459
> Singularity: Scientific containers for mobility of compute
> Gregory M. Kurtzer, Vanessa Sochat, Michael W. Bauer
> Published: May 11, 2017
> https://doi.org/10.1371/journal.pone.0177459
