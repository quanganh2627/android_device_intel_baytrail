TARGET_BOARD_PLATFORM := baytrail
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(PLATFORM_PATH)/init.debug.rc:root/init.debug.rc \
    $(PLATFORM_PATH)/props.baytrail.rc:root/props.platform.rc \
    $(PLATFORM_PATH)/maxtouch.fw:system/etc/firmware/maxtouch.fw \
    $(PLATFORM_PATH)/mxt1664S-touchscreen.idc:system/usr/idc/mxt1664S-touchscreen.idc

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
    libfs-subsystem \
    libproperty-subsystem \
    libremote-processor \
    remote-process \
    charger \
    charger_res_images \
    parameter

# Add HdmiSettings app
PRODUCT_PACKAGES += \
    HdmiSettings

# Ota and Ota Downloader
PRODUCT_PACKAGES += \
    Ota \
    OtaDownloader

# light
PRODUCT_PACKAGES += \
    lights.$(PRODUCT_DEVICE)
