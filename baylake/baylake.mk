ifeq (,$(filter $(PRODUCT_NAME),baylake_next baylake_edk2))
PRODUCT_NAME := baylake
endif
PRODUCT_DEVICE := baylake

# Include product path
include $(LOCAL_PATH)/baylakepath.mk

#NXP Effects
-include vendor/intel/PRIVATE/lifevibes/nxp.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg \
    $(PLATFORM_PATH)/maxtouch.fw:system/etc/firmware/maxtouch.fw

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

PRODUCT_PACKAGES += \
        wifi_bcm_43241

#hdmi audio HAL
PRODUCT_PACKAGES += \
       audio.hdmi.$(PRODUCT_DEVICE)

#widi audio HAL
PRODUCT_PACKAGES += \
       audio.widi.$(PRODUCT_DEVICE)

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
      $(LOCAL_PATH)/audio_effects_adge_webrtc.conf:system/etc/audio_effects.conf


# thermal config files
PRODUCT_COPY_FILES += \
         $(LOCAL_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(LOCAL_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

# crashlog conf
PRODUCT_COPY_FILES += \
         $(LOCAL_PATH)/crashlog.conf:system/etc/crashlog.conf

# Include base makefile
include $(LOCAL_PATH)/device.mk

