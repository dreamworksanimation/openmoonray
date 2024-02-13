# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0 

# Install Rocky Linux 9 packages for building MoonRay
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


dnf install -y epel-release
dnf config-manager --enable crb

# not required if you are not building with GPU support
if [ $install_cuda -eq 1 ] 
then
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
    dnf install -y cuda-runtime-11-8 cuda-toolkit-11-8
fi

dnf install -y libglvnd-devel

dnf install -y gcc gcc-c++

dnf install -y bison flex wget git python3 python3-devel patch \
               giflib-devel libmng libtiff-devel libjpeg-devel \
               libatomic libuuid-devel openssl-devel curl-devel \
               freetype-devel zlib-devel

dnf install -y lsb_release

mkdir -p /installs/{bin,lib,include}
cd /installs
wget https://kojihub.stream.centos.org/kojifiles/packages/libcgroup/0.42.2/5.el9/x86_64/libcgroup-0.42.2-5.el9.x86_64.rpm
wget https://kojihub.stream.centos.org/kojifiles/packages/libcgroup/0.42.2/5.el9/x86_64/libcgroup-devel-0.42.2-5.el9.x86_64.rpm
dnf install libcgroup-0.42.2-5.el9.x86_64.rpm -y
dnf install libcgroup-devel-0.42.2-5.el9.x86_64.rpm -y

wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz
tar xzf cmake-3.23.1-linux-x86_64.tar.gz

dnf install -y blosc blosc-devel #1.21.2
dnf install -y boost boost-chrono boost-date-time boost-filesystem boost-python3 boost-program-options boost-regex boost-thread boost-system boost-devel #1.75.0
dnf install -y lua lua-libs lua-devel #5.4.4
dnf install -y openvdb openvdb-libs openvdb-devel #9.1.0
dnf install -y tbb tbb-devel python3-tbb #2020.3
dnf install -y log4cplus log4cplus-devel #2.0.5
dnf install -y cppunit cppunit-devel #1.15.1
dnf install -y libmicrohttpd libmicrohttpd-devel #0.9.72

# not required if you are not building the GUI apps
if [ $install_qt -eq 1 ]
then
    dnf install -y qt5-qtbase-devel qt5-qtscript-devel
fi

export PATH=/installs/cmake-3.23.1-linux-x86_64/bin:/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
