DEVICE_PATH := $(call my-dir)

include vendor/intel/common/AndroidBoard.mk

# Add socwatchdk driver
-include $(TOP)/device/intel/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk

LOCAL_PATH := $(DEVICE_PATH)

# Trick the installer boot image into using Google mkbootimg with private var.
$(PRODUCT_OUT)/installer/installer_boot.img: MKBOOTIMG := out/host/linux-x86/bin/mkbootimg

# wifi
ifeq ($(strip $(BOARD_HAVE_WIFI)),true)
include $(LOCAL_PATH)/wifi/WifiRules.mk
endif

ifeq ($(IA_NCG),true)
ADDITIONAL_BUILD_PROPERTIES += dalvik.vm.startup-ncg=spec
ADDITIONAL_BUILD_PROPERTIES += dalvik.vm.ncg-mode=O1
endif

-include $(TOP)/$(KERNEL_SRC_DIR)/AndroidKernel.mk
-include $(TOP)/hardware/intel/linux-2.6/AndroidKernel.mk

.PHONY: build_kernel
ifeq ($(TARGET_KERNEL_SOURCE_IS_PRESENT),true)
build_kernel: get_kernel_from_source
else
build_kernel: get_kernel_from_tarball
endif

.PHONY: get_kernel_from_tarball
get_kernel_from_tarball:
	tar -xv -C $(PRODUCT_OUT) -f $(TARGET_KERNEL_TARBALL)

bootimage: build_kernel


systemimg_gz: bootimage droid

ADDITIONAL_DEFAULT_PROPERTIES += persist.ril-daemon.disable=0 \
                                 persist.radio.ril_modem_state=1

firmware: ifwi_firmware dnx_firmware

$(TARGET_PRODUCT): systemimg_gz firmware recoveryimage #otapackage

ifeq ($(TARGET_USE_DROIDBOOT),true)
$(TARGET_PRODUCT): droidbootimage
endif

.PHONY: $(TARGET_PRODUCT)
$(TARGET_PRODUCT): installer_img

# There is a dependency issue between fstab.baytrail which depends on bootimage and the installer.
# Fix it here but fstab should probably have a dependency to the ramdisk, not the bootimage.
installer_img: bootimage

#
# EFI for android
#
$(PRODUCT_OUT)/kernel.efi: $(PRODUCT_OUT)/kernel
	cp "$(PRODUCT_OUT)/kernel" "$(PRODUCT_OUT)/kernel.efi"

$(PRODUCT_OUT)/startup.nsh: $(PRODUCT_OUT)/kernel $(TARGET_DEVICE_DIR)/BoardConfig.mk
	echo "fs1:\kernel.efi $(BOARD_KERNEL_CMDLINE) initrd=ramdisk-installer.img.gz" > "$(PRODUCT_OUT)/startup.nsh"
	echo "fs0:\kernel.efi $(BOARD_KERNEL_CMDLINE) initrd=ramdisk.img" >> "$(PRODUCT_OUT)/startup.nsh"

### TEMPORARY: override flashfiles defined in common until baytrail supports them.
flashfiles: $(PRODUCT_OUT)/partition.tbl baylake_ifwi
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
	@cp $(TARGET_OUT_IFWIS)/ifwi_capsule.bin $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin
	@cp $(TARGET_OUT_IFWIS)/ifwi.bin $(FLASHFILE_PATH)/dediprog.rom
	@cp $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin $(FLASHFILE_PATH)/
	@zip -j $(FLASHFILE_PATH)/$(FLASHFILE_NAME) $(FLASHFILE_PATH)/*
	@find $(FLASHFILE_PATH) -name '*.zip' -prune -o -type f -exec rm {} \;
### TEMPORARY: override flashfiles -- END
