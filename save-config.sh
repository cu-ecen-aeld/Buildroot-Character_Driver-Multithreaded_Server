#!/bin/bash

# ------------------------------------------------------------------------------
# File        : save_config.sh
#
# Description : Saves the current Buildroot configuration as a reusable
#               defconfig and optionally exports the Linux kernel defconfig
#               if a custom kernel configuration is enabled.
#
# Purpose     : Allows persistence of modified Buildroot + kernel settings so
#               that builds can be reproduced without manual reconfiguration.
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Move to script directory to ensure relative paths work correctly
cd `dirname $0`

# Load shared configuration variables
source shared.sh

# Ensure external config directory exists for storing custom defconfigs
mkdir -p base_external/configs/

# Save current Buildroot configuration as a defconfig file
make -C buildroot savedefconfig BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}


# Kernel defconfig handling (only if custom kernel config is enabled)
if [ -e buildroot/.config ] && [ ls buildroot/output/build/linux-*/.config 1> /dev/null 2>&1 ]; then

	# Check if Buildroot is configured to use a custom kernel config file
	grep "BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE" buildroot/.config > /dev/null
	if [ $? -eq 0 ]; then
		echo "Saving linux defconfig"

		# Export current kernel configuration back to defconfig file
		make -C buildroot linux-update-defconfig
	fi
fi

# Kernel configuration is saved back to the Buildroot defconfig when custom kernel config is used