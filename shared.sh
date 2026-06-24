#!/bin/sh

# ------------------------------------------------------------------------------
# File        : shared.sh
#
# Description : Shared configuration variables used across Buildroot helper
#               scripts. Defines default and project-specific defconfig paths
#               used for QEMU-based ARM64 builds.
#
# Purpose     : Centralizes Buildroot configuration references to avoid
#               duplication across build, clean, and utility scripts.
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Default Buildroot defconfig for QEMU ARM64 virtual machine
QEMU_DEFCONFIG=configs/qemu_aarch64_virt_defconfig

# Custom modified defconfig used for AESD project-specific configuration
MODIFIED_QEMU_DEFCONFIG=base_external/configs/aesd_qemu_defconfig
AESD_MODIFIED_DEFCONFIG=${MODIFIED_QEMU_DEFCONFIG}

# Relative path to modified defconfig from Buildroot directory
AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT=../${AESD_MODIFIED_DEFCONFIG}

# Default defconfig used when no custom configuration is available
AESD_DEFAULT_DEFCONFIG=${QEMU_DEFCONFIG}

