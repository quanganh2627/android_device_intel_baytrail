DEVICE_PATH := $(call my-dir)

include vendor/intel/common/AndroidBoard.mk

# Add socwatchdk driver
-include $(TOP)/device/intel/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk

LOCAL_PATH := $(DEVICE_PATH)

# wifi
ifeq ($(strip $(BOARD_HAVE_WIFI)),true)
include $(LOCAL_PATH)/wifi/WifiRules.mk
endif

ifeq ($(IA_NCG),true)
ADDITIONAL_BUILD_PROPERTIES += dalvik.vm.startup-ncg=spec
ADDITIONAL_BUILD_PROPERTIES += dalvik.vm.ncg-mode=O1
endif

systemimg_gz: bootimage droid

ADDITIONAL_DEFAULT_PROPERTIES += persist.ril-daemon.disable=0 \
                                 persist.radio.ril_modem_state=1

firmware: ifwi_firmware dnx_firmware

.PHONY: $(TARGET_PRODUCT)
$(TARGET_PRODUCT): systemimg_gz firmware recoveryimage #otapackage

ifeq ($(TARGET_USE_DROIDBOOT),true)
$(TARGET_PRODUCT): droidbootimage
endif

### TEMPORARY: override flashfiles defined in common until baytrail supports them.
flashfiles: $(PRODUCT_OUT)/partition.tbl
	@$(eval FLASHFILE_PATH := $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/flash_files/build-$(PUBLISH_TARGET_BUILD_VARIANT))
	@$(eval FLASHFILE_NAME := $(GENERIC_TARGET_NAME)-$(PUBLISH_TARGET_BUILD_VARIANT)-fastboot-$(FILE_NAME_TAG).zip)
	@echo "Generating $(FLASHFILE_PATH)/$(FLASHFILE_NAME)"
	@mkdir -p $(FLASHFILE_PATH)
	@rm -rf $(FLASHFILE_PATH)/*
	@cp $(PRODUCT_OUT)/kernel $(FLASHFILE_PATH)/mos_kernel.efi
	@cp $(PRODUCT_OUT)/ramdisk.img $(FLASHFILE_PATH)/mos_ramdisk.img
	@cp $(PRODUCT_OUT)/boot.bin $(FLASHFILE_PATH)/
	@cp $(PRODUCT_OUT)/droidboot.img $(FLASHFILE_PATH)/
	@cp $(PRODUCT_OUT)/recovery.img $(FLASHFILE_PATH)/
	@cp $(INSTALLED_SYSTEMIMG_GZ_TARGET) $(FLASHFILE_PATH)/
	@cp $(TARGET_DEVICE_DIR)/flash.xml $(FLASHFILE_PATH)/
	@cp $(TARGET_DEVICE_DIR)/flash_capsule.xml $(FLASHFILE_PATH)/
	@cp $(OUT)/partition.tbl $(FLASHFILE_PATH)/
	@cp $(IFWI_PREBUILT_PATHS)/capsule.bin $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin
	@cp $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin $(FLASHFILE_PATH)/
	@zip -j $(FLASHFILE_PATH)/$(FLASHFILE_NAME) $(FLASHFILE_PATH)/*
	@find $(FLASHFILE_PATH) -name '*.zip' -prune -o -type f -exec rm {} \;
### TEMPORARY: override flashfiles -- END
