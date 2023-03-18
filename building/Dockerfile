# Dockerfile for openmoonray base build image
# on top of this image, use CMake to install the 
# additional moonray dependencies.

FROM nvidia/cuda:11.4.0-devel-centos7

RUN yum install -y epel-release centos-release-scl.noarch
RUN yum install -y devtoolset-9 devtoolset-9-gcc \
                   devtoolset-9-gcc-c++ devtoolset-9-libatomic-devel
RUN yum install -y bison flex  wget git python3 python3-devel \
                   patch giflib-devel libmng libtiff-devel libjpeg-devel \
                   libatomic libcgroup-devel libuuid-devel \
                   openssl-devel curl-devel

# Not required when using cuda:11.4.0-base-centos7
# RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
RUN yum install -y mesa-libGL
RUN yum install -y cuda-toolkit-11-4

# Not needed if you skip building the GUI apps (CMake -DBUILD_QT_APPS=NO)
RUN yum install -y qt5-qtbase-devel qt5-qtscript-devel

RUN mkdir /installs /installs/bin /installs/lib /installs/include
RUN cd /installs; wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz; tar xzf cmake-3.23.1-linux-x86_64.tar.gz
ENV PATH=/installs/cmake-3.23.1-linux-x86_64/bin:${PATH}
RUN mkdir /build
CMD scl enable devtoolset-9 bash
