PRODUCT_NAME := bigcore

# Include product path
include $(LOCAL_PATH)/bigcorepath.mk

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

PRODUCT_PACKAGES += \
        wifi_bigcore

#hdmi audio HAL
PRODUCT_PACKAGES += \
       audio.hdmi.$(PRODUCT_NAME)

#widi audio HAL
PRODUCT_PACKAGES += \
       audio.widi.$(PRODUCT_NAME)

# parameter-framework files
PRODUCT_PACKAGES += \
    parameter-framework.audio.bigcore

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf

# specific management of audio_effects.conf
PRODUCT_COPY_FILES += \
$(LOCAL_PATH)/mixer_paths_Realtek.xml:system/etc/mixer_paths_Realtek.xml \
$(LOCAL_PATH)/mixer_paths_Analog_Devices.xml:system/etc/mixer_paths_Analog_Devices.xml \
$(LOCAL_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf \
$(LOCAL_PATH)/mixer_paths_unknown.xml:system/etc/mixer_paths_unknown.xml \

# Include base makefile
include $(LOCAL_PATH)/device.mk

