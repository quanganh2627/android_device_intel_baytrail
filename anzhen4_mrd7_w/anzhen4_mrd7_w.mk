ifeq ($(PRODUCT_NAME),)
PRODUCT_NAME := anzhen4_mrd7_w
endif

#3G dongle support.if true,only support 3g dongle,no support modem; otherwise, only support modem,no support 3g dongle
SUPPORT_3G_DONGLE_ONLY := true

ifeq ($(SUPPORT_3G_DONGLE_ONLY),true)
# Dongle files
PRODUCT_COPY_FILES += \
               $(LOCAL_PATH)/dongle/connect-chat:system/etc/ppp/connect-chat \
               $(LOCAL_PATH)/dongle/ip-up:system/etc/ppp/ip-up \
               $(LOCAL_PATH)/dongle/ip-down:system/etc/ppp/ip-down \
               $(LOCAL_PATH)/dongle/chat:system/xbin/chat \
               $(LOCAL_PATH)/dongle/usb_modeswitch:system/xbin/usb_modeswitch

#Add 3G Dongle
PRODUCT_PACKAGES += \
   Dongle
endif

BOARD_HAS_CAPSULE := true
TARGET_PARTITIONING_SCHEME := "full-gpt"
TARGET_BIOS_TYPE := "uefi"
HAS_SPINOR := true
USE_FPT := true
BOARD_USE_WARMDUMP := true

# Copy common product apns-conf
COMMON_PATH := device/intel/common
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/apns-conf.xml:system/etc/apns-conf.xml

# Include product path
include $(LOCAL_PATH)/anzhen4_mrd7_w_path.mk

# Dolby DS1
#-include vendor/intel/PRIVATE/dolby_ds1/dolbyds1.mk

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(DEVICE_CONF_PATH)/overlays
KERNEL_DIFFCONFIG := $(LOCAL_PATH)/$(PRODUCT_NAME)_diffconfig

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
     $(DEVICE_CONF_PATH)/goodix_ts.idc:system/usr/idc/goodix_ts.idc

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
        parameter-framework.audio.anzhen4_mrd7_w \
	parameter-framework.vibrator.anzhen4_mrd7_w

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

