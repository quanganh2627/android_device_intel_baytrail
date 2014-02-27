ifeq (,$(filter $(PRODUCT_NAME), byt_m_crb_next byt_m_crb_64))
PRODUCT_NAME := byt_m_crb
endif

# This flag need to be set to true for Wilkins peak WIFI and Blueooth
# card otherwise it should be false for Broadcom.
BOARD_HAS_WILKINS_PEAK_CHIP := true

# Include product path
include $(LOCAL_PATH)/byt_m_crb_path.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(DEVICE_CONF_PATH)/overlays

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(DEVICE_CONF_PATH)/maxtouch_3432S.fw:system/etc/firmware/maxtouch.fw

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
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

#remote submix audio
PRODUCT_PACKAGES += \
       audio.r_submix.default

# parameter-framework files
PRODUCT_PACKAGES += \
        parameter-framework.audio.byt_m_crb

# build the OMX wrapper codecs
PRODUCT_PACKAGES += \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf

# specific management of audio_effects.conf
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf

# crashlog conf
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/crashlog.conf:system/etc/crashlog.conf

# thermal config files
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(DEVICE_CONF_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

# Kdump
PRODUCT_PACKAGES_ENG += kdumpramdisk

# BIOS update capsule file
PRODUCT_PACKAGES += byt_m_bios.cap

# Include base makefile
include $(LOCAL_PATH)/device.mk

