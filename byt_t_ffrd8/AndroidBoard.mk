include $(PLATFORM_PATH)/AndroidBoard.mk

# parameter-framework
include $(DEVICE_PATH)/parameter-framework/AndroidBoard.mk

# FG config file
include $(DEVICE_PATH)/fg_config/AndroidBoard.mk

ADDITIONAL_DEFAULT_PROPERTIES += persist.ril-daemon.disable=0
