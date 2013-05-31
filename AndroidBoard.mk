# make file for Baytrail
#

include device/intel/common/AndroidBoard.mk

# Add socwatchdk driver
-include $(TOP)/linux/modules/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk

# Add VISA driver
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/visadk/driver/src/AndroidVISA.mk

# wifi
ifeq ($(strip $(BOARD_HAVE_WIFI)),true)
include $(DEVICE_PATH)/wifi/WifiRules.mk
endif

.PHONY: images firmware $(TARGET_PRODUCT)
firmware: ifwi_firmware
systemimg_gz: droid
# Legacy target - same as 'make images'
$(TARGET_PRODUCT): images

images: firmware bootimage systemimg_gz recoveryimage
ifeq ($(TARGET_USE_DROIDBOOT),true)
images: droidbootimage
endif

# Temporary support for diskinstaller to be used with EFI BIOS.
# -> should go away as this is not needed with PSI firmware + OTG
include $(PLATFORM_PATH)/diskinstaller/rules.mk

include $(PLATFORM_PATH)/flashfiles_workaround.mk
