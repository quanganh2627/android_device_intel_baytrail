include $(PLATFORM_PATH)/AndroidBoard.mk

# parameter-framework
include $(DEVICE_PATH)/parameter-framework/AndroidBoard.mk

ADDITIONAL_DEFAULT_PROPERTIES += persist.ril-daemon.disable=0
