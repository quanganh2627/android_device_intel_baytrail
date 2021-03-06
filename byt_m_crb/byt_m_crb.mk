ifeq ($(PRODUCT_NAME),)
PRODUCT_NAME := byt_m_crb
endif


# This flag need to be set to true for Wilkins peak WIFI card
# otherwise it should be false for Broadcom.
BOARD_HAS_WILKINS_PEAK_CHIP := true

# Set to true to use certified Intel prebuilt binaries.
CONFIG_USE_INTEL_CERT_BINARIES := false

# Copy common product apns-conf
COMMON_PATH := device/intel/common
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/apns-conf.xml:system/etc/apns-conf.xml

# Include product path
include $(LOCAL_PATH)/byt_m_crb_path.mk

BLANK_FLASHFILES_CONFIG := $(DEVICE_CONF_PATH)/blankflashfiles.json

# IFWI
ifeq ($(TARGET_BIOS_TYPE),"uefi")
ifeq ($(BOARD_USE_64BIT_KERNEL),true)
PRODUCT_PACKAGES += \
    ifwi_uefi_byt_m_64_dediprog \
    ifwi_uefi_byt_m_64_capsule
else
PRODUCT_PACKAGES += \
    ifwi_uefi_byt_m_dediprog \
    ifwi_uefi_byt_m_capsule
endif
endif
# Dolby DS1
#-include vendor/intel/PRIVATE/dolby_ds1/dolbyds1.mk

# product specific overlays for Intel resources
ifneq ($(BUILD_VANILLA_AOSP), true)
PRODUCT_PACKAGE_OVERLAYS := $(DEVICE_CONF_PATH)/overlays_extensions
endif
# product specific overlays for Vanilla AOSP resources
PRODUCT_PACKAGE_OVERLAYS += $(DEVICE_CONF_PATH)/overlays_aosp

# HDMISettings
PRODUCT_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlays_hdmisettings

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(DEVICE_CONF_PATH)/maxtouch_1664S_8.fw:system/etc/firmware/maxtouch.fw

# This script unmount /mnt/log.Added for aplog enable support.
PRODUCT_COPY_FILES +=  $(DEVICE_CONF_PATH)/umount.sh:system/etc/umount.sh

# Wi-Fi
 PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

ifeq ($(BOARD_HAS_WILKINS_PEAK_CHIP),true)

BOARD_HAVE_BLUETOOTH_IBT := true
BLUETOOTH_HCI_USE_USB := true

# include firmware for wilkins peak bluetooth
$(call inherit-product-if-exists,vendor/intel/hardware/bluetooth/fw/btfw.mk)

PRODUCT_PACKAGES += \
        wifi_intel_wkp \
        hciconfig
 else

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_PACKAGES += \
        wifi_bcm_43241 \
        bt_bcm43241

endif

# Copy sar manager resources
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/sarconfig.xml:system/etc/sarconfig.xml

# Revert me to fg_config.bin instead of fg_config_$(TARGET_PRODUCT) once BZ119617 is resoved
#Fuel gauge related
PRODUCT_PACKAGES += \
       fg_conf fg_config.bin

#remote submix audio
PRODUCT_PACKAGES += \
       audio.r_submix.default

# bcu hal
PRODUCT_PACKAGES += \
    bcu.default

# rapid ril
PRODUCT_PACKAGES += \
    librapid-ril-core \
    librapid-ril-util

# Cell Broadcast
#PRODUCT_PACKAGES += \
    CellBroadcastReceiver

# parameter-framework files
PRODUCT_PACKAGES += \
        parameter-framework.audio.byt_m_crb \
        parameter-framework.routeMgr.byt_m_crb

# MAMGR (Modem Audio Manager)
#PRODUCT_PACKAGES += \
    mamgr

# build the OMX wrapper codecs
#PRODUCT_PACKAGES += \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp

# NFC
#PRODUCT_PACKAGES += \
    nfc_pn544pc

PRODUCT_PROPERTY_OVERRIDES += \
    ro.nfc.se.uicc=false \
    ro.nfc.se.ese=false \
    ro.nfc.clk=xtal

#SARManager
#PRODUCT_PACKAGES += \
    com.intel.internal.telephony.SARManager \
    com.intel.internal.telephony.SARManager.xml

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf

# specific management of audio_pre_effects.conf
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/audio_pre_effects.conf:system/vendor/etc/audio_pre_effects.conf

# CMS configuration files
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/cms_throttle_config.xml:system/etc/cms_throttle_config.xml \
    $(DEVICE_CONF_PATH)/cms_device_config.xml:system/etc/cms_device_config.xml

# Add component-testing applications
#PRODUCT_PACKAGES_ENG += mcd-test

PRODUCT_PACKAGES_DEBUG += \
    run_test_ipc.sh

# thermal config files
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(DEVICE_CONF_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

# crashlog conf
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/crashlog.conf:system/etc/crashlog.conf
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/ingredients.conf:system/etc/ingredients.conf

# Include base makefile
include $(LOCAL_PATH)/device.mk

