ifeq (,$(filter $(PRODUCT_NAME), byt_t_ffrd8_next))
PRODUCT_NAME := byt_t_ffrd8
endif

# Include product path
include $(LOCAL_PATH)/byt_t_ffrd8_path.mk

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
        wifi_bcm_4334x

# Revert me to fg_config.bin instead of fg_config_$(TARGET_PRODUCT) once BZ119617 is resoved
#Fuel gauge related
PRODUCT_PACKAGES += \
       fg_conf fg_config.bin

#remote submix audio
PRODUCT_PACKAGES += \
       audio.r_submix.default

# rapid ril
PRODUCT_PACKAGES += \
    librapid-ril-core \
    librapid-ril-util

# Cell Broadcast
PRODUCT_PACKAGES += \
    CellBroadcastReceiver

# parameter-framework files
PRODUCT_PACKAGES += \
        libimc-subsystem \
        parameter-framework.audio.byt_t_ffrd8

# MAMGR (Modem Audio Manager)
PRODUCT_PACKAGES += \
    libmamgr-xmm

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

# Include base makefile
include $(LOCAL_PATH)/device.mk

