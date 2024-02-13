# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0 

# Install Centos 7 packages for building MoonRay
# source this script in bash

install_qt=1
install_cuda=1
for i in "$@" 
do
case ${i,,} in
    --noqt|-noqt)
        install_qt=0
    ;;
    --nocuda|-nocuda)
        install_cuda=0
    ;;
    *)
        echo "Unknown option: $i"
        return 1
    ;;
esac
done


yum install -y epel-release centos-release-scl.noarch
yum install -y devtoolset-9 devtoolset-9-gcc \
                   devtoolset-9-gcc-c++ devtoolset-9-libatomic-devel
yum install -y bison flex  wget git python3 python3-devel \
                   patch giflib-devel libmng libtiff-devel libjpeg-devel \
                   libatomic libcgroup-devel libuuid-devel \
                   openssl-devel curl-devel freetype-devel
yum install -y redhat-lsb-core

# not required if you are not building with GPU support
if [ $install_cuda -eq 1 ] 
then
    yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
    yum install -y mesa-libGL
    yum install -y cuda-toolkit-11-4
fi

# not required if you are not building the GUI apps
if [ $install_qt -eq 1 ]
then
    yum install -y qt5-qtbase-devel qt5-qtscript-devel
fi

mkdir /installs /installs/bin /installs/lib /installs/include
cd /installs; wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz; tar xzf cmake-3.23.1-linux-x86_64.tar.gz
export PATH=/installs/cmake-3.23.1-linux-x86_64/bin:${PATH}
scl enable devtoolset-9 bash
