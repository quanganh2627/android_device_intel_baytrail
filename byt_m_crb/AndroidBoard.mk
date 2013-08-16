include $(PLATFORM_PATH)/AndroidBoard.mk

# parameter-framework
include $(DEVICE_PATH)/parameter-framework/AndroidBoard.mk

ifeq ($(TARGET_BUILD_VARIANT),eng)
-include $(TOP)/vendor/intel/tools/PRIVATE/log_infra/kdump_root/AndroidKdumpDK.mk
ALL_DEFAULT_INSTALLED_MODULES += kdumpramdisk
endif
