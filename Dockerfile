# Dockerfile for openmoonray base build image
FROM nvidia/cuda:11.4.0-base-centos7 as build
ARG BUILD_JOBS=64

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


# when changing the shell using podman, the --format docker flag must be used
shell ["/usr/bin/scl", "enable", "devtoolset-9"]
RUN echo "source scl_source enable devtoolset-9" >> /etc/profile.d/moonray-development.sh
RUN mkdir -p /usr/local/

# install everything in /usr/local, optix install script is @ /root/optix.sh
RUN mkdir -p /root/build/dependancies
WORKDIR /root/build
RUN git clone --branch v3.23.1 --depth 1 https://github.com/Kitware/CMake.git 
RUN cd CMake && ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release && make -j ${BUILD_JOBS} && make install
 
COPY . /root/build/openmoonray
RUN  mkdir -p /usr/local
RUN if [[ -e /root/build/openmoonray/optix.sh ]]; then chmod 755 /root/build/openmoonray/optix.sh && /root/build/openmoonray/optix.sh --prefix=/usr/local --exclude-subdir --skip-license; else echo "please copy the correct version of optix into openmoonray/optix.sh"; false; fi
  
WORKDIR /root/build/dependancies
RUN cmake -D installDir:PATH=/usr/local ../openmoonray/building
RUN make -j ${BUILD_JOBS}

WORKDIR /root/build/openmoonray
# hack a bit because the container-release has hard-coded paths.
RUN ln -s /usr/local /installs
RUN cmake --preset container-release 
RUN cmake --build --preset container-release -- -j ${BUILD_JOBS}
RUN cmake --install /build --prefix /usr/local

WORKDIR /root
run rm -rf /build /root/build


FROM nvidia/cuda:11.4.0-base-centos7

RUN yum install -y epel-release centos-release-scl.noarch
RUN yum install -y python3 giflib libmng libtiff libjpeg \
                   libatomic libcgroup libuuid \
                   openssl curl

# Not required when using cuda:11.4.0-base-centos7
# RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
RUN yum install -y mesa-libGL
RUN yum install -y cuda-toolkit-11-4

RUN yum install -y qt5-qtbase-gui

COPY --from=build /usr/local /usr/local
# setup the environment for Moonray
ENV REZ_MOONRAY_ROOT=/usr/local/bin
ENV RDL2_DSO_PATH=/usr/local/rdl2dso:/usr/local/rdl2dso.proxy
ENV MOONRAY_CLASS_PATH=/usr/local/shader_json
ENV PXR_PLUGINPATH_NAME=/usr/local/plugin/usd
ENV ARRAS_SESSION_PATH=/usr/local/sessions
ENV PXR_PLUGIN_PATH=/usr/local/plugin/usd

RUN mkdir -p /project
WORKDIR /project
ENTRYPOINT ["/usr/local/bin/moonray"]
