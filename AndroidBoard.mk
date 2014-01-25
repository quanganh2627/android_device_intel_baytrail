# make file for Baytrail
#

include device/intel/common/AndroidBoard.mk

# Add socwatchdk driver
-include $(TOP)/linux/modules/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/socwatchdk/src/AndroidSOCWatchDK.mk

# Add VISA driver
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/visadk/driver/src/AndroidVISA.mk

# Add LM driver
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/lmdk/AndroidLMDK.mk

# Add ioaccess driver for PETS
ifeq ($(TARGET_BUILD_VARIANT), eng)
include linux/modules/ioaccess/AndroidIOA.mk
endif

# wifi
ifeq ($(strip $(BOARD_HAVE_WIFI)),true)
include $(DEVICE_CONF_PATH)/wifi/WifiRules.mk
endif

.PHONY: images firmware $(TARGET_PRODUCT)

$(TARGET_SYSTEM): droid
# Legacy target - same as 'make images'
$(TARGET_PRODUCT): images

images: firmware bootimage $(TARGET_SYSTEM) recoveryimage
ifeq ($(TARGET_USE_USERFASTBOOT),true)
images: droidbootimage
endif

blank_flashfiles: recoveryimage
