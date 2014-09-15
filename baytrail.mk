TARGET_BOARD_PLATFORM := baytrail
TARGET_BOARD_SOC := valleyview2
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(PLATFORM_CONF_PATH)/init.byt.gengfx.rc:root/init.platform.gengfx.rc \
    $(PLATFORM_CONF_PATH)/props.baytrail.rc:root/props.platform.rc \
    $(PLATFORM_CONF_PATH)/atmel_mxt_ts.idc:system/usr/idc/atmel_mxt_ts.idc \
    $(PLATFORM_CONF_PATH)/synaptics_dsx.idc:system/usr/idc/synaptics_dsx.idc

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/init.nodebug.rc:root/init.debug.rc
else
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/init.debug.rc:root/init.debug.rc
endif


# Kernel Watchdog
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdogd.rc:root/init.watchdog.rc
ifeq ($(TARGET_BIOS_TYPE),"uefi")
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdog_uefi.sh:root/init.watchdog.sh
PRODUCT_PACKAGES += \
    uefivar
else
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdog.sh:root/init.watchdog.sh
PRODUCT_PACKAGES += \
    ia32fw
endif

# Firmware versioning
ifeq ($(TARGET_BIOS_TYPE),"uefi")
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/firmware/smbios_firmware_props.rc:root/init.firmware.rc
PRODUCT_PACKAGES += \
    intel_fw_props
else
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/firmware/pidv_firmware_props.rc:root/init.firmware.rc
endif

#keylayout file
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/intel_short_long_press.kl:system/usr/keylayout/baytrailaudio_Intel_MID_Audio_Jack.kl

# tinyalsa
PRODUCT_PACKAGES += \
    libtinyalsa \
    tinyplay \
    tinycap \
    tinymix

# parameter-framework
PRODUCT_PACKAGES += \
    libparameter \
    parameter-connector-test \
    libxmlserializer \
    liblpe-subsystem \
    libtinyalsa-subsystem \
    libfs-subsystem \
    libproperty-subsystem \
    libroute-subsystem \
    parameter

# Add charger app
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# remote-process for parameter-framework tuning interface
PRODUCT_PACKAGES_DEBUG += \
    libremote-processor \
    remote-process

# Add FPT and TXEManuf
# Android-L disabled not building due to removed timeb.h
#PRODUCT_PACKAGES_ENG += FPT TXEManuf

# Add HdmiSettings app
#PRODUCT_PACKAGES += \
    HdmiSettings

# Ota and Ota Downloader
#PRODUCT_PACKAGES += \
    Ota \
    OtaDownloader

# Crash Report / crashinfo
PRODUCT_PACKAGES_DEBUG += \
    crash_package

#Opencl
#PRODUCT_PACKAGES += opencl_bundle

# light
PRODUCT_PACKAGES += \
    lights.$(PRODUCT_DEVICE)

# sensorhub
#PRODUCT_PACKAGES += \
    sensorhubd      \
    libsensorhub    \
    psh_bk.bin      \
    fwupdatetool    \
    fwupdate_script.sh

# rfid/pss service
#PRODUCT_PACKAGES += \
    rfid_monzaxd

# IPTrak
#PRODUCT_PACKAGES_DEBUG += \
    IPTrak

# WebRTC reference app
#PRODUCT_PACKAGES += \
    videoP2P

#PRODUCT_PACKAGES_DEBUG += \
    WebRTCDemo

# Identity Protection Technology (IPT)
PRODUCT_PACKAGES += \
    libiha \
    libsepipt \
    EPIDClientConfig.txt \
    epid_paramcert.dat \
    IPT_Bundle \
    PAVP_Group_BYTEPIDPROD_Public_Keys.bin \
    PAVP_Group_VLV2EPIDPREPROD_Public_Keys.bin \
    PAVP_Group_VLV2EPIDPROD_Public_Keys.bin

# Security service
PRODUCT_PACKAGES += \
    com.intel.security.service.sepmanager \
    com.intel.security.lib.sepdrmjni \
    libsepdrmjni libiha btxei \
    libsepipt SepService

PRODUCT_PACKAGES_DEBUG += \
    TXEI_TEST TXEI_SEC_TOOLS

# Prebuilt HAL packages - Graphics
PRODUCT_PACKAGES += \
    hwcomposer.$(TARGET_BOARD_PLATFORM) \
    libdrm_intel \
    ufo \
    ufo_test

# Keymaster HAL
PRODUCT_PACKAGES += \
    keystore.$(TARGET_BOARD_PLATFORM)

# Adding for Netflix app to do dynamic resolution switching
ADDITIONAL_BUILD_PROPERTIES += ro.streaming.video.drs=true
# Disable the graceful shutdown in case of "longlong" press on power
ADDITIONAL_BUILD_PROPERTIES += ro.disablelonglongpress=true
