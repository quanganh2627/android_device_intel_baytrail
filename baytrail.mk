TARGET_BOARD_PLATFORM := baytrail
TARGET_BOARD_SOC := valleyview2
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(PLATFORM_PATH)/init.byt.gengfx.rc:root/init.platform.gengfx.rc \
    $(PLATFORM_PATH)/props.baytrail.rc:root/props.platform.rc \
    $(PLATFORM_PATH)/atmel_mxt_ts.idc:system/usr/idc/atmel_mxt_ts.idc

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/init.nodebug.rc:root/init.debug.rc
else
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.debug.rc:root/init.debug.rc
endif


# Kernel Watchdog
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdogd.rc:root/init.watchdog.rc

#keylayout file
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/intel_short_long_press.kl:system/usr/keylayout/baytrailaudio_Intel_MID_Audio_Jack.kl

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
    parameter

# Add charger app
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# remote-process for parameter-framework tuning interface
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    libremote-processor \
    remote-process
endif

# Adobe AIR
PRODUCT_PACKAGES += \
    AdobeAIR \
    libCore.so

# Add HdmiSettings app
PRODUCT_PACKAGES += \
    HdmiSettings

# Ota and Ota Downloader
PRODUCT_PACKAGES += \
    Ota \
    OtaDownloader

# Crash Report / crashinfo
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    crash_package
endif

# light
PRODUCT_PACKAGES += \
    lights.$(PRODUCT_DEVICE)

# sensorhub
PRODUCT_PACKAGES += \
    sensorhubd

# IAFW
PRODUCT_PACKAGES += \
    ia32fw
