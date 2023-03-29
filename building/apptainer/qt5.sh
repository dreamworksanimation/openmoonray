#!/bin/bash
mkdir /qtbuild
mkdir -p /installs/Qt-5.15
cd /
git clone git://code.qt.io/qt/qt5.git
cd qt5
git checkout v5.15.6-lts-lgpl
./init-repository --module-subset=qtbase,qtscript
cd /qtbuild
CC=clang CXX=clang++ ../qt5/configure -opensource -confirm-license -prefix /installs/Qt-5.15
make -j$(nproc)
make install
cp -r /installs/Qt-5.15/bin/moc /usr/lib64/qt5/bin
rm -rf /installs/Qt-5.15 /qtbuild
# moonray_gui build error with Qt 5.15.3
# fix needs moc from Qt5.15.6
# https://bugreports.qt.io/browse/QTBUG-80990