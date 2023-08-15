# Dockerfile for openmoonray base build image
# on top of this image, use CMake to install the 
# additional moonray dependencies.

FROM centos:7

RUN yum install -y epel-release centos-release-scl.noarch
RUN yum install -y devtoolset-9 devtoolset-9-gcc \
                   devtoolset-9-gcc-c++ devtoolset-9-libatomic-devel
RUN yum install -y bison flex  wget git python3 python3-devel \
                   patch giflib-devel libmng libtiff-devel libjpeg-devel \
                   libatomic libcgroup-devel libuuid-devel \
                   openssl-devel curl-devel

# Not needed if you skip building the GUI apps (CMake -DBUILD_QT_APPS=NO)
RUN yum install -y qt5-qtbase-devel qt5-qtscript-devel

RUN mkdir /installs /installs/bin /installs/lib /installs/include
RUN cd /installs; wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz; tar xzf cmake-3.23.1-linux-x86_64.tar.gz
ENV PATH=/installs/cmake-3.23.1-linux-x86_64/bin:${PATH}
RUN mkdir /build
CMD scl enable devtoolset-9 bash
