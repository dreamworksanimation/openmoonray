# -*- coding: utf-8 -*-
import os, sys

name = 'openmoonray'

if 'early' not in locals() or not callable(early):
    def early(): return lambda x: x

@early()
def version():
    """
    Increment the build in the version.
    """
    _version = '0.1'
    from rezbuild import earlybind
    return earlybind.version(this, _version)

description = 'OpenMoonRay package'

authors = [
    'PSW Rendering and Shading',
    'moonbase-dev@dreamworks.com'
]

help = ('For assistance, '
        "please contact the folio's owner at: moonbase-dev@dreamworks.com")

variants = [
    ['os-CentOS-7', 'opt_level-optdebug', 'refplat-vfx2020.3', 'gcc-6.3.x.2', 'amorphous-8', 'openvdb-8', 'usd_core-0.20.8.x.2'],
    ['os-CentOS-7', 'opt_level-debug', 'refplat-vfx2020.3', 'gcc-6.3.x.2', 'amorphous-8', 'openvdb-8', 'usd_core-0.20.8.x.2'],
    ['os-CentOS-7', 'opt_level-optdebug', 'refplat-vfx2021.0', 'gcc-9.3.x.1', 'amorphous-8', 'openvdb-8', 'usd_core-0.21.8.x.2'],
    ['os-CentOS-7', 'opt_level-debug', 'refplat-vfx2021.0', 'gcc-9.3.x.1', 'amorphous-8', 'openvdb-8', 'usd_core-0.21.8.x.2'],
    ['os-CentOS-7', 'opt_level-optdebug', 'refplat-vfx2021.0', 'clang-13', 'gcc-9.3.x.1', 'amorphous-8', 'openvdb-8', 'usd_core-0.21.8.x.2'],
    ['os-CentOS-7', 'opt_level-optdebug', 'refplat-vfx2022.0', 'gcc-9.3.x.1', 'amorphous-9', 'openvdb-9', 'imath-3', 'usd_core-0.22.5.x'],
    ['os-CentOS-7', 'opt_level-debug', 'refplat-vfx2022.0', 'gcc-9.3.x.1', 'amorphous-9', 'openvdb-9', 'imath-3', 'usd_core-0.22.5.x'],
]

requires = [
    'amorphous',
    'boost',
    'cuda-11.3.0.x',
    'curl_no_ldap-7.49.1',
    'embree-3.12.1.x.16',
    'jsoncpp-0.6.0',
    'libmicrohttpd-0.9.37.x.0',
    'log4cplus-1.1.2.x.2',
    'lua',
    'mkl',
    'openexr',
    'openimagedenoise',
    'openimageio-2<2.4',
    'opensubdiv-3.5.0.x.0',
    'openvdb',
    'optix-7.3.0.x',
    'qt',
    'random123-1.08.3',
    'tbb',
    'usd_core',
    'usd_imaging',
    'uuid-1.0.0',
    'zlib-1.2.8.x.2'
]

private_build_requires = [
    'cmake',
    'cppunit-1.15.1.x',
    'ispc-1.14.1.x',
    'python-2.7|3.7|3.9'
]

# Create dictionary of tests for the rez-test command
commandstr = lambda i: "cd build/"+os.path.join(*variants[i])+"; ctest -j $(nproc) -L 'unit'"
testentry = lambda i: ("variant%d" % i,
                       { "command": commandstr(i),
                         "requires": ["cmake-3.23"] + variants[i] } )
testlist = [testentry(i) for i in range(len(variants))]
tests = dict(testlist)

def commands():
    prependenv('ARRAS_SESSION_PATH', '{root}/sessions')
    prependenv('CMAKE_PREFIX_PATH', '{root}')
    prependenv('HOUDINI_PATH', '{root}/houdini')
    prependenv('HDMOONRAY_DOUBLESIDED', '1')
    prependenv('LD_LIBRARY_PATH', '{root}/lib64')
    prependenv('MOONRAY_CLASS_PATH', '{root}/coredata')
    prependenv('MOONRAY_DSO_PATH', '{root}/rdl2dso')
    prependenv('PATH', '{root}/bin')
    prependenv('PXR_PLUGIN_PATH', '{root}/plugin')
    prependenv('PXR_PLUGIN_PATH', '{root}/adapters')
    prependenv('PYTHONPATH', '{root}/python/lib/$PYTHON_NAME')
    prependenv('RDL2_DSO_PATH', '{root}/rdl2dso')

uuid = '7f6d2e07-4a15-4a50-87d6-9535e05d1f93'

config_version = 0
