# Copyright 2024-2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

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
    _version = '2.32'
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
    [   # variant 0
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2023.1',
        'usd_core-0.23.8.x',
        'openimageio-2.4.8.0.x',
        'gcc-11.x',
        'openvdb-11',
        'zlib-1.2.11.x'
    ],
    [   # variant 1
        'os-rocky-9',
        'opt_level-debug',
        'refplat-vfx2023.1',
        'usd_core-0.23.8.x',
        'openimageio-2.4.8.0.x',
        'gcc-11.x',
        'openvdb-11',
        'zlib-1.2.11.x'
    ],
    [   # variant 2
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2023.1',
        'usd_core-0.24.3.x',
        'openimageio-2.4.8.0.x',
        'gcc-11.x',
        'openvdb-11',
        'zlib-1.2.11.x'
    ],
    [   # variant 3
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2023.1',
        'usd_core-0.22.5.x',
        'openimageio-2.3.20.0.x',
        'gcc-11.x',
        'openvdb-11',
        'zlib-1.2.11.x'
    ],
    [   # variant 4
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2023.1',
        'usd_core-0.22.5.x',
        'openimageio-2.3.20.0.x',
        'clang-17.0.6.x',
        'openvdb-10',
        'zlib-1.2.11.x'
    ],
    [   # variant 5
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2024.0',
        'usd_core-0.24.3.x',
        'openimageio-2.4.8.0.x',
        'gcc-11.x',
        'openvdb-11',
        'zlib-1.2.11.x'
    ],
    [   # variant 6
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2025.0',
        'usd_core-0.25.5.1.x',
        'openimageio-3.0',
        'gcc-11.x',
        'openvdb-12',
        'zlib-1.2.11.x'
    ],
    [   # variant 7
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-houdini21.0',
        'usd_core-0.25.5.1.x',
        'openimageio-3.0',
        'gcc-11.x',
        'openvdb-12',
        'zlib-1.2.11.x'
    ],
    [   # variant 8
        'os-rocky-9',
        'opt_level-optdebug',
        'refplat-vfx2022.0',
        'usd_core-0.22.5.x',
        'openimageio-2.3.20.0.x',
        'gcc-9.3.x.1',
        'openvdb-9',
        'zlib-1.2.11.x',
        'opensubdiv-3.5.0.x.0'
    ],
]

conf_rats_variants = variants[0:2]

# Add ephemeral package to each variant.
for i, variant in enumerate(variants):
    variant.insert(0, '.openmoonray_variant-%d' % i)

requires = [
    'boost',
    'cuda-12.1.0.x',
    'curl_no_ldap-7.49.1.x',
    'embree-4.2.0.x',
    'imath-3',
    'jsoncpp-1.9.5',
    'libmicrohttpd-0.9.71.x.1',
    'log4cplus-1.1.2.x',
    'lua',
    'mkl',
    'openexr',
    'openimagedenoise',
    'opensubdiv',
    'openvdb',
    'optix-7.6.0.x',
    'qt',
    'random123-1.08.3',
    'tbb',
    'usd_imaging',
    'uuid-1.0.0',
]

dwa_extras = [
    'amorphous',
    'alembic_utilities-10',
    'cfx_fur-10',
    'geometry',
    'gtypes',
    'oceanlib-10',
    'willow-10.2.0.x.4.34',
]

private_build_requires = [
    'alembic',
    'cmake',
    'cppunit',
    'ispc-1.20.0.x',
    'python',
]

# If moonshine_dwa is available add the extra rez packages that it needs into the requires.
if os.path.exists('moonray/moonshine_dwa/CMakeLists.txt'):
    requires.extend(dwa_extras)

# Create dictionary of tests for the rez-test command
# First, add unit tests entry for each variant
commandstr = lambda i: "cd build/"+os.path.join(*variants[i])+"; ctest --no-tests=error -j $(nproc) -L 'unit' --output-on-failure"
testentry = lambda i: ("variant%d" % i,
                       { "command": commandstr(i),
                         "requires": ["cmake"],
                         "on_variants": {
                             "type": "requires",
                             "value": [".openmoonray_variant-%d" % i]
                         },
                         "run_on": "explicit",
                     })
testlist = [testentry(i) for i in range(len(variants))]

# Second, add a retry unit tests entry for each variant
retrycommandstr = lambda i: "cd build/"+os.path.join(*variants[i])+"; ctest --no-tests=error -j $(nproc) -L 'unit' --rerun-failed --output-on-failure"
retrytestentry = lambda i: ("retry_variant%d" % i,
                            { "command": retrycommandstr(i),
                              "requires": ["cmake"],
                              "on_variants": {
                                  "type": "requires",
                                  "value": [".openmoonray_variant-%d" % i]
                              },
                              "run_on": "explicit",
                          })

testlist.extend([retrytestentry(i) for i in range(len(variants))])

# Next, add rats tests entry
rats_variant = 0
rats_cmd = "cd build/"+os.path.join(*variants[rats_variant])+"; ctest --no-tests=error -j 16 -L 'rats' -L 'render|diff' --output-on-failure"
rats_testentry = { "command": rats_cmd,
                         "requires": ["cmake"],
                         "on_variants": {
                             "type": "requires",
                             "value": [".openmoonray_variant-%d" % rats_variant]
                         },
                         "run_on": "explicit",
                     }
testlist.append(("rats", rats_testentry))

# Next, add retry rats tests entry
rats_variant = 0
retry_rats_cmd = "cd build/"+os.path.join(*variants[rats_variant])+"; ctest --no-tests=error -j 16 -L 'rats' -L 'render|diff' --rerun-failed --output-on-failure"
retry_rats_testentry = { "command": retry_rats_cmd,
                         "requires": ["cmake"],
                         "on_variants": {
                             "type": "requires",
                             "value": [".openmoonray_variant-%d" % rats_variant]
                         },
                         "run_on": "explicit",
                     }
testlist.append(("retry_rats", retry_rats_testentry))

# Next, add rats_debug tests entry
rats_debug_variant = 1
rats_debug_cmd = "cd build/"+os.path.join(*variants[rats_debug_variant])+"; ctest --no-tests=error -j 16 -L 'rats' -L 'render' --output-on-failure"
rats_debug_testentry = { "command": rats_debug_cmd,
                         "requires": ["cmake"],
                         "on_variants": {
                             "type": "requires",
                             "value": [".openmoonray_variant-%d" % rats_debug_variant]
                         },
                         "run_on": "explicit",
                     }
testlist.append(("rats-debug", rats_debug_testentry))

# Next, add retry_rats_debug tests entry
rats_debug_variant = 1
retry_rats_debug_cmd = "cd build/"+os.path.join(*variants[rats_debug_variant])+"; ctest --no-tests=error -j 16 -L 'rats' -L 'render' --rerun-failed --output-on-failure"
retry_rats_debug_testentry = { "command": retry_rats_debug_cmd,
                               "requires": ["cmake"],
                               "on_variants": {
                                   "type": "requires",
                                   "value": [".openmoonray_variant-%d" % rats_debug_variant]
                               },
                               "run_on": "explicit",
                           }
testlist.append(("retry_rats-debug", retry_rats_debug_testentry))

# Build final dictionary for rez-test command
tests = dict(testlist)

def commands():
    prependenv('ARRAS_SESSION_PATH', '{root}/sessions')
    prependenv('CMAKE_PREFIX_PATH', '{root}')
    prependenv('REZ_MOONRAY_ROOT', '{root}')
    prependenv('HOUDINI_PATH', '{root}/houdini')
    prependenv('HDMOONRAY_DOUBLESIDED', '1')
    prependenv('LD_LIBRARY_PATH', '{root}/lib64')
    prependenv('MOONRAY_CLASS_PATH', '{root}/coredata')
    prependenv('MOONRAY_DSO_PATH', '{root}/rdl2dso')
    prependenv('PATH', '{root}/bin')
    prependenv('PXR_PLUGIN_PATH', '{root}/plugin/pxr') # for legacy DWA USD builds
    prependenv('PXR_PLUGINPATH_NAME', '{root}/plugin/pxr')
    prependenv('PYTHONPATH', '{root}/python/lib/$PYTHON_NAME')
    prependenv('RDL2_DSO_PATH', '{root}/rdl2dso')

uuid = '7f6d2e07-4a15-4a50-87d6-9535e05d1f93'

config_version = 0
