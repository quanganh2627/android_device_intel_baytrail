LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_USE_USERFASTBOOT),true)
# Plug-in libary for Droidboot
include $(CLEAR_VARS)
LOCAL_MODULE := libdbadbd
LOCAL_SRC_FILES := dbadbd.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES := bootable/userfastboot
LOCAL_CFLAGS := -Wall -Werror -Wno-unused-parameter
ifneq ($(DROIDBOOT_NO_GUI),true)
LOCAL_CFLAGS += -DUSE_GUI
endif
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libdbupdate
LOCAL_SRC_FILES := dbupdate.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES := bootable/userfastboot
LOCAL_CFLAGS := -Wall -Werror -Wno-unused-parameter
ifneq ($(DROIDBOOT_NO_GUI),true)
LOCAL_CFLAGS += -DUSE_GUI
endif
include $(BUILD_STATIC_LIBRARY)

DBUPDATE_MK_BLOB := $(LOCAL_PATH)/mkbblob.py
DBUPDATE_FILES := $(TARGET_EFI_APPS)

$(DBUPDATE_BLOB): \
		$(DBUPDATE_FILES) \
		$(DBUPDATE_MK_BLOB)
	$(hide) mkdir -p $(dir $@)
	$(hide) $(DBUPDATE_MK_BLOB) \
			--output $@ \
			$(DBUPDATE_FILES)

endif # TARGET_USE_USERFASTBOOT
