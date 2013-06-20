PRODUCT_NAME := byt_t_ffrd10

# Include product path
include $(LOCAL_PATH)/byt_t_ffrd10_path.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

# Crash Report / crashinfo
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    CrashReport \
    crashinfo \
    com.google.gson \
    com.google.gson.xml \
    logconfig \
    crashparsing \
    crashparsing.xml
endif

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/maxtouch.cfg:system/etc/firmware/maxtouch.cfg

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

PRODUCT_PACKAGES += \
        wifi_bcm_43241

#hdmi audio HAL
PRODUCT_PACKAGES += \
       audio.hdmi.$(PRODUCT_NAME)

#widi audio HAL
PRODUCT_PACKAGES += \
       audio.widi.$(PRODUCT_NAME)

# parameter-framework files
PRODUCT_PACKAGES += \
    parameter-framework.audio.byt_t_ffrd10

# build the OMX wrapper codecs
ifeq ($(USE_INTEL_MDP),true)
PRODUCT_PACKAGES += \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp
endif

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf

# specific management of audio_effects.conf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf

# thermal config files
PRODUCT_COPY_FILES += \
         $(LOCAL_PATH)/thermal_sensor_config.xml:system/etc/thermal_sensor_config.xml \
         $(LOCAL_PATH)/thermal_throttle_config.xml:system/etc/thermal_throttle_config.xml

# Include base makefile
include $(LOCAL_PATH)/device.mk

