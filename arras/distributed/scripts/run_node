#!/bin/bash
# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# run node on the local machine, using coordinator also on local machine

SOURCEDIR="$( dirname -- "${BASH_SOURCE[0]:-$0}";)"
export PATH=${SOURCEDIR}:${PATH}
export RDL2_DSO_PATH=${SOURCEDIR}/../rdl2dso
arras4_node --coordinator-host localhost --coordinator-port 8888 -l 5 --no-consul