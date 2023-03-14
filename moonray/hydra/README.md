# Usage
To use the moonray hydra plugin, you need to generate JSON descriptions for all the shaders. These are
required to register the shaders as nodes with Ndr.

```bash
rel_root=<release root dir>
export RDL2_DSO_PATH=${rel_root}/rdl2dso.proxy
${rel_root}/bin/rdl2_json_exporter --out ${rel_root}/shader_json/ --sparse
```

(Note the trailing slash on the output directory name)

To use the plugin, you must be in an environment setup to use usd, and set a number of additional environment variables:

```bash
# tells the Ndr plugins where to find the shader descriptions
export MOONRAY_CLASS_PATH=${rel_root}/shader_json
# tells Moonray where to find shader dsos
export RDL2_DSO_PATH=${rel_root}/rdl2dso.proxy:${rel_rool}/rdl2dso
# tells Arras where to find the session definition files
export ARRAS_SESSION_PATH=${rel_root}/sessions/hdMoonray
# adds the Arras runtime execComp to the path
export PATH=${rel_root}/bin:${PATH}
# adds the pxr plugins to the plugin path 
export PXR_PLUGINPATH_NAME=${rel_root}/plugin/usd:${PXR_PLUGINPATH_NAME}
```

When using the DWA USD build, you need to set PXR_PLUGIN_PATH in place of PXR_PLUGINPATH_NAME.
There may also be problems with the DWA build of Python3 embedded into USD : you may need to set $PYTHONHOME and $PYTHONPATH

You can test the setup by rendering a USD scene with hd_render:

```bash
${rel_root}/bin/hd_render -in <usd_file> -out <exr_file>
```
