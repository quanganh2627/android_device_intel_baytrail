TARGET_BOARD_PLATFORM := baytrail
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include vendor/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(BYT_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(BYT_PATH)/init.debug.rc:root/init.debug.rc \
    $(BYT_PATH)/props.baytrail.rc:root/props.platform.rc \
    $(BYT_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(BYT_PATH)/mxt1664S-touchscreen.idc:system/usr/idc/mxt1664S-touchscreen.idc

# parameter-framework
PRODUCT_PACKAGES += \
    libparameter \
    parameter-connector-test \
    libxmlserializer \
    liblpe-subsystem \
    libamixer-subsystem \
    libalsactl-subsystem \
    libbluetooth-subsystem \
    libfs-subsystem \
    libproperty-subsystem \
    libremote-processor \
    remote-process \
    parameter
