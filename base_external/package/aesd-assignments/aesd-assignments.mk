# ------------------------------------------------------------------------------
# File        : aesd-assignments.mk
#
# Description : Buildroot package definition for AESD assignments.
#               Fetches the server and driver programs from a Github repository,
#               builds the AESD socket server and AESD character driver, and
#               installs binaries, kernel module, and scripts into the
#               target root filesystem.
#
# Purpose     : Integrates the AESD socket server and AESD character device
#               driver into the Buildroot-generated embedded Linux image.
#
# Components  : - aesdsocket (TCP socket server)
#   			- aesdchar (character device driver)
#   			- startup/shutdown init scripts
#   			
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Remote Git repository containing server and driver source code and scripts
AESD_ASSIGNMENTS_VERSION = 'baccc837531b556dcba20fdb2b68419985b736fd' 
AESD_ASSIGNMENTS_SITE = 'git@github.com:cu-ecen-aeld/Programs_for_Server_and_Device_Driver.git'
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

# Build AESD socket server and AESD character device driver module
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(TARGET_CPPFLAGS) -Iinclude -I../aesd-char-driver" \
		-C $(@D)/server all

	$(MAKE) -C $(@D)/aesd-char-driver \
    ARCH=$(KERNEL_ARCH) \
    CROSS_COMPILE=$(TARGET_CROSS) \
    KERNEL_SRC=$(LINUX_DIR) \
    modules
endef

# Install binaries and scripts into target filesystem
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS	
	# Install socket server binary
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin/ 

	# Install socket server SysV init script for automatic startup and shutdown
	$(INSTALL) -d $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop.sh $(TARGET_DIR)/etc/init.d/S99aesdsocket

	# Install AESD char kernel module
	$(INSTALL) -d $(TARGET_DIR)/lib/modules
	$(INSTALL) -m 0644 $(@D)/aesd-char-driver/aesdchar.ko $(TARGET_DIR)/lib/modules/

	# Install char driver SysV init scripts for automatic load and unload
	$(INSTALL) -d $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar-start-stop.sh $(TARGET_DIR)/etc/init.d/S90aesdchar

	# Install AESD character driver helper scripts
	$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_load $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_unload $(TARGET_DIR)/usr/bin/
endef

# Register AESD character driver as a kernel module package
$(eval $(kernel-module))

# Register this as a Buildroot generic package
$(eval $(generic-package))

