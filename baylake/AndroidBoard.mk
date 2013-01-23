LOCAL_PATH := $(call my-dir)

include vendor/intel/common/AndroidBoard.mk

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

$(TARGET_DEVICE): systemimg_gz firmware recoveryimage #otapackage

ifeq ($(TARGET_USE_DROIDBOOT),true)
$(TARGET_DEVICE): droidbootimage
endif