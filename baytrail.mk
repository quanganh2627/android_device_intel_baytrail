TARGET_BOARD_PLATFORM := baytrail
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include vendor/intel/common/common.mk

# USB port turn around and initialization
USB_PATH := vendor/intel/baytrail
PRODUCT_COPY_FILES += \
        $(USB_PATH)/init.byt.usb.rc:root/init.platform.usb.rc
