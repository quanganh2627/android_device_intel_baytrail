ifeq (,$(filter $(PRODUCT_NAME),baylake_next baylake_edk2 baylake_64))
PRODUCT_NAME := baylake
endif

# Include product path
include $(LOCAL_PATH)/baylakepath.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(DEVICE_CONF_PATH)/overlays

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(PLATFORM_CONF_PATH)/maxtouch.fw:system/etc/firmware/maxtouch.fw

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

PRODUCT_PACKAGES += \
        wifi_bcm_43241

#remote submix audio
PRODUCT_PACKAGES += \
    audio.r_submix.default

# parameter-framework files
PRODUCT_PACKAGES += \
    parameter-framework.audio.baylake

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

# thermal config files
PRODUCT_COPY_FILES += \
         $(DEVICE_CONF_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(DEVICE_CONF_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

# crashlog conf
PRODUCT_COPY_FILES += \
        $(DEVICE_CONF_PATH)/crashlog.conf:system/etc/crashlog.conf

# Include base makefile
include $(LOCAL_PATH)/device.mk

