#!/bin/bash
sed -i 's@rel_root=${sourcedir}/..@rel_root=/installs/openmoonray@' scripts/setup.sh
sed -i 's@${rel_root}/shader_json@/tmp/shader_json@' scripts/setup.sh

sed -i 's/python/python39/' moonray/hydra/CMakeLists.txt
sed -i 's/python/python39/' moonray/hydra/hdMoonray/CMakeLists.txt
sed -i 's/python/python39/' moonray/moonshine_usd/CMakeLists.txt
sed -i '11s/python/python39/' moonray/scene_rdl2/mod/python/py_scene_rdl2/CMakeLists.txt

sed -i 's/Boost::python/Boost::python39/' moonray/hydra/hdMoonray/cmd/hd_cmd/hd_render/CMakeLists.txt
sed -i 's/Boost::python/Boost::python39/' moonray/hydra/hdMoonray/cmd/hd_cmd/hd_usd2rdl/CMakeLists.txt
sed -i 's/Boost::python/Boost::python39/' moonray/scene_rdl2/mod/python/py_scene_rdl2/CMakeLists.txt

ag -l _GLIBCXX_USE_CXX11 . | xargs -n1 sed -i 's/_GLIBCXX_USE_CXX11_ABI=0/_GLIBCXX_USE_CXX11_ABI=1/' $1
ag -l "\-\-werror" . | grep .cmake | xargs -n1 sed -i 's/--werror/#--werror/' $1
ag -l env.DWAForceWarningAsError | xargs -n1 sed -i 's/env.DWAForceWarningAsError/#env.DWAForceWarningAsError/' $1

ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/lib64/libatomic.so.1 /usr/lib64/libatomic.so

sed -i '/BsdfHairLobes.h/a #include <array>' moonray/moonray/lib/rendering/shading/bsdf/hair/BsdfHairOneSampler.h
sed -i '/Color.h/a #include <array>' moonray/moonshine/lib/common/noise/Worley.h
sed -i '/#include <functional>/a #include <string>' moonray/moonray_arras/mcrt_dataio/lib/engine/merger/MsgSendHandler.h
sed -i '/#include <vector>/a #include <array>' moonray/moonray/lib/rendering/rt/gpu/GPUPrimitive.h
sed -i '/#include <float.h>/a #include <limits>' moonray/moonray/lib/rendering/rndr/RenderTimingRecord.h
sed -i '/#pragma once/a #include <shared_mutex>' moonray/scene_rdl2/include/scene_rdl2/render/util/ReaderWriterMutex.h
sed -i '/#include <shared_mutex>/a #include <mutex>' moonray/scene_rdl2/include/scene_rdl2/render/util/ReaderWriterMutex.h
sed -i '/#pragma once/a #include <functional>' moonray/moonray_arras/mcrt_computation/lib/engine/mcrt/McrtUpdate.h
