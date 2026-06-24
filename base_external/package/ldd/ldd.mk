# ------------------------------------------------------------------------------
# File        : ldd.mk
#
# Description : Buildroot package definition for LDD3 kernel modules.
#               Fetches the LDD3 repository and integrates the
#               misc-modules and scull drivers into the Buildroot
#               image build process.
#
# Components  : - misc-modules
#   			- scull
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Remote repository containing LDD3 example driver modules
LDD_VERSION = 57aa6ae7886363f7f835812dc19c7e97b3ad4eeb
LDD_SITE = git@github.com:cu-ecen-aeld/Building_Example_Driver_Modules.git
LDD_SITE_METHOD = git

# Build both misc-modules and scull subdirectories
LDD_MODULE_SUBDIRS = misc-modules scull

# Build as external kernel modules against Buildroot's kernel
$(eval $(kernel-module))
$(eval $(generic-package))