#!/bin/bash
# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# run arras_render, using coordinator on local machine
# specify rdla file to render as an argument

SOURCEDIR="$( dirname -- "${BASH_SOURCE[0]:-$0}";)"
export RDL2_DSO_PATH=${SOURCEDIR}/../rdl2dso.proxy
export ARRAS_SESSION_PATH=${SOURCEDIR}/../sessions/arras_render
${SOURCEDIR}/arras_render --host localhost --port 8888 --rdl $1 --current-env
