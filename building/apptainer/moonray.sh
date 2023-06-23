#!/bin/bash
# ===========
#    Usage
# ===========
#
# export WORKDIR=$(pwd)
# bash ./openmoonray/building/apptainer/moonray.sh
# 

# Apptainer build settings
mkdir -p $WORKDIR/.moonray_build_cache
mkdir -p $WORKDIR/.moonray_build_tmp
export CACHEDIR=$WORKDIR/.moonray_build_cache
export TMPDIR=$WORKDIR/.moonray_build_tmp

# MoonRay build root directory
export MOONRAY_SRC_ROOT=$WORKDIR/openmoonray
export MOONRAY_BUILD_ROOT=$MOONRAY_SRC_ROOT/building/apptainer

# Move NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh to MoonRay build root directory
cp NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh $MOONRAY_BUILD_ROOT

echo "[INFO] Build BEGIN"
cd $MOONRAY_BUILD_ROOT
echo "[INFO] Build Base Image"
apptainer build moonray-rocky9-base.sif moonray-rocky9-base.def
echo "[INFO] Build Dependencies" 
apptainer build moonray-rocky9-depbuild.sif moonray-rocky9-depbuild.def
rm -f moonray-rocky9-base.sif
echo "[INFO] Build MoonRay"
apptainer build moonray-rocky9.sif moonray-rocky9.def
rm -f moonray-rocky9-depbuild.sif
echo "[INFO] Build END"
apptainer build minicoord.sif minicoord.def

# Clean up
rm -rf $CACHEDIR
rm -rf $TMPDIR

echo "[INFO] Current Directory: $(pwd)"
echo "[INFO] Quick Test"
echo "cd $MOONRAY_BUILD_ROOT"
echo "apptainer shell --nv moonray-rocky9.sif"
echo "MoonRay> moonray_gui -in /openmoonray/testdata/rectangle.rdla -out /tmp/rectangle.exr"
