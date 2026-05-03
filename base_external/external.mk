
include $(sort $(wildcard $(BR2_EXTERNAL_project_base_PATH)/package/*/*.mk))

# wildcard -> Look inside every subdirectory of package/ and list all .mk files you find
