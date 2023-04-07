# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# setup environment variables to use release

sourcedir="$( dirname -- "${BASH_SOURCE[0]:-$0}";)"
rel_root=${sourcedir}/..
echo "Setting up release in ${rel_root}"

# NB required for Arras to function (it needs to find execComp)
export PATH=${rel_root}/bin:${PATH}

# tell moonray where to find dsos
export RDL2_DSO_PATH=${rel_root}/rdl2dso

# tell moonray where to find shaders file for XPU mode.
# it will look for ${REZ_MOONRAY_ROOT}/shaders/GPUShaders.ptx
export REZ_MOONRAY_ROOT=${rel_root}

# tell Arras where to find session files
export ARRAS_SESSION_PATH=${rel_root}/sessions

# tell Hydra Ndr plugins where to find shader descriptions
export MOONRAY_CLASS_PATH=${rel_root}/shader_json

# add Hydra plugins to path
export PXR_PLUGIN_PATH=${rel_root}/plugin/usd:${PXR_PLUGIN_PATH}
export PXR_PLUGINPATH_NAME=${rel_root}/plugin/usd:${PXR_PLUGINPATH_NAME}

# create shader descriptions if they don't exist
if [ ! -d "${rel_root}/shader_json" ]
then
    echo "Building shader descriptions..."
    ${rel_root}/bin/rdl2_json_exporter --out ${rel_root}/shader_json/ --sparse
    echo "...done"
fi
