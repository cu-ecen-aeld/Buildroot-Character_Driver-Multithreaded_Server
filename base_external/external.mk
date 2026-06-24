# ------------------------------------------------------------------------------
# File        : external.mk
#
# Description : Discovers and includes all package makefiles
#               provided by the external Buildroot layer.
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

include $(sort $(wildcard $(BR2_EXTERNAL_project_base_PATH)/package/*/*.mk))

