#!/bin/bash

# ------------------------------------------------------------------------------
# File        : build.sh
#
# Description : Build script for Buildroot-based embedded Linux system.
#               It initializes submodules and configures Buildroot using either
#               a saved defconfig or a default configuration before building
#               the full system image.
#
# Purpose     : Automates reproducible embedded Linux image generation
#               (ARM64) with integrated applications and kernel modules.
#
# Author	  : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Load shared Buildroot configuration variables used across scripts
source shared.sh

# External Buildroot packages (applications, kernel modules, and related services)
EXTERNAL_REL_BUILDROOT=../base_external

# Initialize and synchronize git submodules (Buildroot + external package tree)
git submodule init
git submodule sync
git submodule update

set -e 

# Ensure script runs from its own directory
cd `dirname $0`

# ------------------------------------------------------------------------------
# Buildroot configuration selection
# ------------------------------------------------------------------------------

# Configuration does not exist
if [ ! -e buildroot/.config ]
then
	echo "MISSING BUILDROOT CONFIGURATION FILE"

	# If a modified defconfig exists, use it as base configuration
	if [ -e ${AESD_MODIFIED_DEFCONFIG} ]
	then
		echo "USING ${AESD_MODIFIED_DEFCONFIG}"

		# Generate Buildroot config using modified defconfig
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
	
	# If no modified config exists, fall back to default defconfig
	else	
		echo "Run ./save_config.sh to save this as the default configuration in ${AESD_MODIFIED_DEFCONFIG}"
		echo "Then add packages as needed to complete the installation, re-running ./save_config.sh as needed"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_DEFAULT_DEFCONFIG}
	fi

# Existing configuration path
else
	echo "USING EXISTING BUILDROOT CONFIG"
	echo "To force update, delete .config or make changes using make menuconfig and build again."
	make -C buildroot BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}

fi
