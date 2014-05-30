ifeq ($(PRODUCT_NAME),)
PRODUCT_NAME := byt_t_crv2
endif

BOARD_HAS_CAPSULE := true
TARGET_PARTITIONING_SCHEME := "full-gpt"
TARGET_BIOS_TYPE := "uefi"
HAS_SPINOR := true
USE_FPT := true
BOARD_DO_COLD_RESET_AFTER_KERNEL_WD_WARM_RESET := true
BOARD_USE_WARMDUMP := true

ifeq ($(BOARD_USE_64BIT_KERNEL),true)
PRODUCT_PACKAGES += \
    ifwi_uefi_byt_crv2_64_dediprog \
    ifwi_uefi_byt_crv2_64_stage2 \
    ifwi_uefi_byt_crv2_64_capsule
else
PRODUCT_PACKAGES += \
    ifwi_uefi_byt_crv2_dediprog \
    ifwi_uefi_byt_crv2_stage2 \
    ifwi_uefi_byt_crv2_capsule
endif

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

# sensor driver config
PRODUCT_PACKAGES += sensor_config.bin

PRODUCT_PACKAGES += \
        wifi_rtl_8723

# Revert me to fg_config.bin instead of fg_config_$(TARGET_PRODUCT) once BZ119617 is resoved
#Fuel gauge related
PRODUCT_PACKAGES += \
       fg_conf fg_config.bin fg_config_xpwr.bin

#remote submix audio
PRODUCT_PACKAGES += \
       audio.r_submix.default

# bcu hal
PRODUCT_PACKAGES += \
    bcu.default

# parameter-framework files
PRODUCT_PACKAGES += \
        libimc-subsystem \
        parameter-framework.audio.byt_t_crv2

# build the OMX wrapper codecs
PRODUCT_PACKAGES += \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp

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

