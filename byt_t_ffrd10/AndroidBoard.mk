DEVICE_PATH := $(call my-dir)

include device/intel/baytrail/AndroidBoard.mk

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

include $(BYT_PATH)/flashfiles_workaround.mk
