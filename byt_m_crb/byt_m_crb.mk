ifeq (,$(filter $(PRODUCT_NAME), byt_m_crb_next))
PRODUCT_NAME := byt_m_crb
endif
# Include product path
include $(LOCAL_PATH)/byt_m_crb_path.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

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
       audio.hdmi.$(PRODUCT_DEVICE)

#widi audio HAL
PRODUCT_PACKAGES += \
       audio.widi.$(PRODUCT_DEVICE)

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
    $(LOCAL_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf

# crashlog conf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/crashlog.conf:system/etc/crashlog.conf

# Include base makefile
include $(LOCAL_PATH)/device.mk

