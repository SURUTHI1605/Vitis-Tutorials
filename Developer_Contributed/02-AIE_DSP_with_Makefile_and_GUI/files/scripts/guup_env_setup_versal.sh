#!/bin/bash
#
# Copyright (C) 2022, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# -------------------------
# Setup common environments
# - Vitis Library Path
# -------------------------
#source $WRK_DIR/$TUTORIAL/files/script/env_setup.sh

# ----------------------------
# Environment Setup for Versal
# ----------------------------

##un comment the next to lines for GUUP emulation from my DESKTOP
export COMMON_IMAGE_VERSAL=/opt/xilinx/common/xilinx-versal-common-v${RELEASE}    # MY DESKTOP to EMULATE GUUP
export SDKTARGETSYSROOT=${VITIS_SYSROOTS} # MY DESKTOP to emulate GUUP
## comment the above two lines and uncomment this one to work on the real GUUP 
#export COMMON_IMAGE_VERSAL=/home/danieleb/common/xilinx-versal-common-v${RELEASE}  # my GUUP

echo Setting Up COMMON_IMAGE_VERSAL=${COMMON_IMAGE_VERSAL}

# Run Environment setup to get SDKTARGETSYSROOT and CXX
unset LD_LIBRARY_PATH
source ${COMMON_IMAGE_VERSAL}/environment-setup-cortexa72-cortexa53-xilinx-linux


# For using createdts in Sprite
export _JAVA_OPTIONS="-Duser.home=/tmp"
