# Include base makefile
include $(LOCAL_PATH)/device.mk

LOCAL_PATH := $(TOP)/vendor/intel/baytrail/baylake

PRODUCT_NAME := baylake

# device specific overlay folder
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

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

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.direct.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml

PRODUCT_PACKAGES += \
        wifi_bcm_43241

# parameter-framework files
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/parameter-framework/XML/Structure/Audio/AudioClass.xml:system/etc/parameter-framework/Structure/Audio/AudioClass.xml \
        $(LOCAL_PATH)/parameter-framework/XML/Structure/Audio/Realtek_RT5640Subsystem.xml:system/etc/parameter-framework/Structure/Audio/Realtek_RT5640Subsystem.xml \
        $(COMMON_PATH)/parameter-framework/XML/Structure/Audio/ConfigurationSubsystem.xml:system/etc/parameter-framework/Structure/Audio/ConfigurationSubsystem.xml \
        $(LOCAL_PATH)/parameter-framework/XML/Structure/Audio/LPESubsystem.xml:system/etc/parameter-framework/Structure/Audio/LPESubsystem.xml \
        $(LOCAL_PATH)/parameter-framework/XML/Structure/Audio/LPEMixerSubsystem.xml:system/etc/parameter-framework/Structure/Audio/LPEMixerSubsystem.xml \
        $(LOCAL_PATH)/parameter-framework/XML/Settings/Audio/AudioRoutingConfigurableDomains.xml:system/etc/parameter-framework/Settings/Audio/AudioRoutingConfigurableDomains.xml \
        $(COMMON_PATH)/parameter-framework/SCRIPTS/parameter:system/bin/parameter

ifeq ($(TARGET_BUILD_VARIANT),eng)
 PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/parameter-framework/XML/ParameterFrameworkConfiguration.xml:system/etc/parameter-framework/ParameterFrameworkConfiguration.xml
else
 PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/parameter-framework/XML/ParameterFrameworkConfigurationNoTuning.xml:system/etc/parameter-framework/ParameterFrameworkConfiguration.xml
endif

#alsa conf
ALSA_CONF_PATH := external/alsa-lib/
PRODUCT_COPY_FILES += \
    $(ALSA_CONF_PATH)/src/conf/alsa.conf:system/usr/share/alsa/alsa.conf
