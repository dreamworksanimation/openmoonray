#!/bin/bash
# ===========
#    Usage
# ===========
#
# export WORKDIR=$(pwd)
# bash ./openmoonray/building/Apptainer/build.sh
# 

# Make cache directory and tmp directory
mkdir -p ${WORKDIR}/.moonray_build_cache
mkdir -p ${WORKDIR}/.moonray_build_tmp
export CACHEDIR=${WORKDIR}/.moonray_build_cache
export TMPDIR=${WORKDIR}/.moonray_build_tmp

# Copy OptiX installer script
cp ${WORKDIR}/NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh ${WORKDIR}/openmoonray/building/Rocky9/optix.sh

# Build MoonRay container
cd ${WORKDIR}/openmoonray/building/Apptainer
apptainer build -B ${WORKDIR}:/workdir ${WORKDIR}/moonray.sif moonray.def

# Build minicoord container
apptainer build -B ${WORKDIR}:/workdir ${WORKDIR}/minicoord.sif minicoord.def

# Clean up cache directory and tmp directory
rm -rf ${CACHEDIR}
rm -rf ${TMPDIR}

cd ${WORKDIR}
