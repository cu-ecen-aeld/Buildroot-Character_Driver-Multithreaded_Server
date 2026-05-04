
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################
AESD_ASSIGNMENTS_VERSION = 'cbe62831ff1a01ad5ad20f46b306949977708d3d'
AESD_ASSIGNMENTS_SITE = 'git@github.com:cu-ecen-aeld/Programs_for_Server_and_Device_Driver.git'
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

# Build the server
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/server all
endef

# Install application and init script
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS	
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin/ 

	# Install aesdsocket startup script
	$(INSTALL) -d $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop.sh $(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

$(eval $(generic-package))
# tell buildroot that its a generic package
