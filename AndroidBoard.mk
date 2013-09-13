# make file for Baytrail
#

include device/intel/common/AndroidBoard.mk

ifeq (, $(findstring next, $(TARGET_PRODUCT)))
# Add socwatchdk driver (only if not on kernel next)
-include $(TOP)/linux/modules/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/socwatchdk/src/AndroidSOCWatchDK.mk
endif

# Add VISA driver
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/visadk/driver/src/AndroidVISA.mk

# wifi
ifeq ($(strip $(BOARD_HAVE_WIFI)),true)
include $(DEVICE_PATH)/wifi/WifiRules.mk
endif

.PHONY: images firmware $(TARGET_PRODUCT)

$(TARGET_SYSTEM): droid
# Legacy target - same as 'make images'
$(TARGET_PRODUCT): images

images: firmware bootimage $(TARGET_SYSTEM) recoveryimage
ifeq ($(TARGET_USE_DROIDBOOT),true)
images: droidbootimage
endif

# Temporary support for diskinstaller to be used with EFI BIOS.
# -> should go away as this is not needed with PSI firmware + OTG
include $(PLATFORM_PATH)/diskinstaller/rules.mk

blank_flashfiles: recoveryimage
