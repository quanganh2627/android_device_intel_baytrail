LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := byt_m_rpt_btns.kl
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := byt_m_rpt_btns.kl
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

include $(PLATFORM_PATH)/AndroidBoard.mk

ifeq ($(TARGET_BUILD_VARIANT),user)
flashfiles: publish_linux_tools
endif

flashfiles: liveimg provimg
# parameter-framework
include $(DEVICE_CONF_PATH)/parameter-framework/AndroidBoard.mk

liveimg:
	@rm -rf $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)
	@mkdir -p $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)
	@cp $(PRODUCT_OUT)/live.img $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)/
	@$(ACP) -rpf $(PRODUCT_OUT)/iago/images/*.img $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)/
	@cp $(HOST_OUT)/bin/adb  $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)/
	@cp $(HOST_OUT)/bin/fastboot $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)/

provimg:
	@cp $(PRODUCT_OUT)/provision.img $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/uefi-images/$(TARGET_BUILD_VARIANT)/

# 'dbimages' for use with Droidboot or sync_img
.PHONY: dbimages
dbimages: $(PRODUCT_OUT)/system.img.gz \
          recoveryimage \
          bootimage \
          userdataimage

DBUPDATE_BLOB := $(PRODUCT_OUT)/dbupdate.bin

ifeq ($(TARGET_STAGE_USERFASTBOOT),true)
dbimages: userfastboot-bootimage $(DBUPDATE_BLOB)
droidcore: dbimages
flashfiles: dbimages
endif
