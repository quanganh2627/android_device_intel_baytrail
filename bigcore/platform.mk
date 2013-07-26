TARGET_BOARD_PLATFORM := bigcore
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.bigc.usb.rc:root/init.platform.usb.rc \
    $(PLATFORM_PATH)/init.debug.rc:root/init.debug.rc \
    $(PLATFORM_PATH)/props.bigcore.rc:root/props.platform.rc \
    $(PLATFORM_PATH)/maxtouch.fw:system/etc/firmware/maxtouch.fw \
    $(PLATFORM_PATH)/atmel_mxt_ts.idc:system/usr/idc/atmel_mxt_ts.idc

# Kernel Watchdog
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdogd.rc:root/init.watchdog.rc

# parameter-framework
PRODUCT_PACKAGES += \
    libparameter \
    parameter-connector-test \
    libxmlserializer \
    liblpe-subsystem \
    libtinyamixer-subsystem \
    libtinyalsactl-subsystem \
    libbluetooth-subsystem \
    libfs-subsystem \
    libproperty-subsystem \
    libremote-processor \
    remote-process \
    charger \
    charger_res_images \
    parameter

# light
PRODUCT_PACKAGES += \
    lights.$(PRODUCT_DEVICE)
