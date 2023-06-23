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

This helper script will build base image, dependencies and MoonRay.

```bash
> export WORKDIR=$(pwd)
> bash ./openmoonray/building/apptainer/moonray.sh
```

* MoonRay Container called `moonray-rocky9.sif` as single executable file

Execute container to get MoonRay shell. All the necessary environment variables are already set in this shell.

```bash
> ./openmoonray/building/apptainer/moonray-rocky9.sif
> MoonRay> 
```

Exit from MoonRay shell to conituning rest of the procedures.

```bash
> MoonRay> exit
```

---
## 2. Deploy MoonRay Container
---

Move MoonRay container to your host `$PATH` for better usability.

For Rocky Linux 8 and Rocky Linux9

```bash
> cd ./openmoonray/building/apptainer
> mv moonray-rocky9.sif ~/bin/moonray-rocky9.sif
> moonray-rocky9.sif
> MoonRay>
```

For Ubuntu Ubuntu 20.04 and 22.04

```bash
> mkdir ~/bin
> cd ./openmoonray/building/apptainer
> mv moonray-rocky9.sif ~/bin/moonray-rocky9.sif
> echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
> source ~/.bashrc
> moonray-rocky9.sif
> MoonRay>
```

---
## 3. Running MoonRay
---

Test data is in `$WORKDIR/openmoonray/testdata` directory on host filesystem. MoonRay Apptainer container is automatically mount your home directory (`$HOME`) inside container. (If `$WORKDIR` is located outside your `$HOME` directory, copy test data under your home directory.)

* moonray

```bash
> moonray-rocky9.sif
MoonRay> cd $WORKDIR/openmoonray/testdata
MoonRay> moonray -in rectangle.rdla -out /tmp/rectangle.exr
```

* moonray_gui

```bash
> moonray-rocky9.sif
MoonRay> cd $WORKDIR/openmoonray/testdata
MoonRay> moonray_gui -in rectangle.rdla -out /tmp/rectangle.exr
```

---
## 4. Portability of Apptainer (formerly Singularity) container
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
