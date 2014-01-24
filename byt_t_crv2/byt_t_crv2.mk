PRODUCT_NAME := byt_t_crv2

BOARD_HAS_CAPSULE := false
FORCE_FLASHFILE_NO_OTA := true
TARGET_PARTITIONING_SCHEME := "full-gpt"
TARGET_BIOS_TYPE := "uefi"
HAS_SPINOR := true
USE_FPT := true

# Copy common product apns-conf
COMMON_PATH := device/intel/common
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/apns-conf.xml:system/etc/apns-conf.xml

# Include product path
include $(LOCAL_PATH)/byt_t_crv2_path.mk

# Dolby DS1
#-include vendor/intel/PRIVATE/dolby_ds1/dolbyds1.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(DEVICE_CONF_PATH)/overlays

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(DEVICE_CONF_PATH)/maxtouch_1664S_8.fw:system/etc/firmware/maxtouch.fw

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

# sensor config files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/sensors/sensor_hal_config_default.xml:system/etc/sensor_hal_config_default.xml \
    $(LOCAL_PATH)/config/sensors/sensor_hal_config_bytcr1.xml:system/etc/sensor_hal_config_bytcr1.xml

# sensor driver config
PRODUCT_PACKAGES += sensor_config.bin

PRODUCT_PACKAGES += \
        wifi_rtl_8723

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

# parameter-framework files
PRODUCT_PACKAGES += \
        libimc-subsystem \
        parameter-framework.audio.byt_t_crv2 \
        parameter-framework.vibrator.baytrail

# build the OMX wrapper codecs
PRODUCT_PACKAGES += \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf

ifndef DOLBY_DAP
# specific management of audio_effects.conf
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf
endif

# CMS configuration files
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/cms_throttle_config.xml:system/etc/cms_throttle_config.xml \
    $(DEVICE_CONF_PATH)/cms_device_config.xml:system/etc/cms_device_config.xml

# thermal config files
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(DEVICE_CONF_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

ifdef DOLBY_DAP
    PRODUCT_PACKAGES += \
        Ds \
        dolby_ds \
        dolby_ds.xml \
        ds1-default.xml \
        DsUI
    ifdef DOLBY_DAP_OPENSLES
        PRODUCT_PACKAGES += \
            libdseffect
    endif
endif #DOLBY_DAP
ifdef DOLBY_UDC
    PRODUCT_PACKAGES += \
        libstagefright_soft_ddpdec
endif #DOLBY_UDC

# Include base makefile
include $(LOCAL_PATH)/device.mk

