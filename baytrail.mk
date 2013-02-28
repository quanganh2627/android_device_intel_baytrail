TARGET_BOARD_PLATFORM := baytrail
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
BYT_PATH := device/intel/baytrail
PRODUCT_COPY_FILES += \
    $(BYT_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(BYT_PATH)/init.debug.rc:root/init.debug.rc
