DEVICE_PATH := $(call my-dir)

include vendor/intel/common/AndroidBoard.mk
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
