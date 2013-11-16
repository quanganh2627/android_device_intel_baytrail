LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := bigcore_device.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery system/core/include/cutils
LOCAL_MODULE := libbigcore_recovery_ui
ifeq ($(RECOVERY_MIN_BATT_CAP),)
RECOVERY_MIN_BATT_CAP := 0
endif
LOCAL_CFLAGS := -Wall -DMIN_BATTERY_LEVEL=$(RECOVERY_MIN_BATT_CAP)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := bigcore_edify.c
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery bootable/iago/include
LOCAL_MODULE := libbigcore_updater
LOCAL_CFLAGS := -Wall -Werror -DKERNEL_ARCH=\"$(TARGET_KERNEL_ARCH)\"
include $(BUILD_STATIC_LIBRARY)

