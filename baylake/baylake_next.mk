PRODUCT_NAME := baylake_next
REF_PRODUCT_NAME := baylake

### There is an override for flashfiles defined in baylake_workaround.mk
### this causes issues for building the OTA/fastboot images since we're
### building a sub-category of the baylake platform.
### To be removed once BZ 105857 implemented
GENERIC_TARGET_NAME := baylake

#KERNEL_DIFFCONFIG := $(TARGET_DEVICE_DIR)/$(PRODUCT_NAME)_diffconfig
# This does not need to be done for two reasons:
# 1. We will have a seperate file called $(PRODUCT_NAME)_diffconfig,
#    which the AndroidKernel.mk file will already process correctly
#    so this line isn't needed.
# 2. At this point in the Android build process the environment
#    variable "TARGET_DEVICE_DIR" is undefined, so all we get for
#    this path in KERNEL_DIFFCONFIG is "/$(PRODUCT_NAME)_diffconfig".
#    Then inside the AndroidKernel.mk we test if KERNEL_DIFFCONFIG
#    is already set so we end up never merging in the kernel config
#    setting from $(PRODUCT_NAME)_diffconfig

KERNEL_SRC_DIR := linux/kernel-next


# Include product path
include $(LOCAL_PATH)/baylakepath.mk

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
    parameter-framework.audio.baylake

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

