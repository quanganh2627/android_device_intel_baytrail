# The Superclass may include PRODUCT_COPY_FILES directives that this subclass
# may want to override.  For PRODUCT_COPY_FILES directives the Android Build
# System ignores subsequent copies that lead to the same destination.  So for
# subclass PRODUCT_COPY_FILES to override properly, the right thing to do is to
# prepend them instead of appending them as usual.  This is done using the
# pattern:
#
# OVERRIDE_COPIES := <the list>
# PRODUCT_COPY_FILES := $(OVERRIDE_COPIES) $(PRODUCT_COPY_FILES)

# Superclass
$(call inherit-product, build/target/product/full_base_telephony.mk)
# product locales configuration
$(call inherit-product, build/target/product/locales_full.mk)
# Include Dalvik Heap Size Configuration
$(call inherit-product, vendor/intel/common/dalvik/phone-xhdpi-1024-dalvik-heap.mk)

# Overrides
PRODUCT_DEVICE := baylake
PRODUCT_MODEL := baylake

PRODUCT_CHARACTERISTICS := nosdcard

# device specific overlay folder
PRODUCT_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlays

OVERRIDE_COPIES := \
    $(LOCAL_PATH)/asound.conf:system/etc/asound.conf \
    $(LOCAL_PATH)/init.baylake.sh:root/init.baylake.sh \
    $(LOCAL_PATH)/init.net.eth0.sh:root/init.net.eth0.sh

PRODUCT_COPY_FILES := $(OVERRIDE_COPIES) $(PRODUCT_COPY_FILES)
# keypad key mapping
PRODUCT_PACKAGES += \
    mrst_keypad.kcm \
    mxt224_key_0.kl \
    mrst_keypad.kl \
    gpio-keys.kl \
    KEYPAD.kl
#    intel_short_long_press.kl

# glib
PRODUCT_PACKAGES += \
    libglib-2.0 \
    array-test \
    array-test \
    mainloop-test \
    libgmodule-2.0 \
    libgobject-2.0 \
    libgthread-2.0

# hardware HAL
#PRODUCT_PACKAGES += \
    audio_hal_ia_controlled_ssp \
    libaudioresample \
    libbluetooth-audio \
    mediabtservice \
    audio.primary.$(PRODUCT_DEVICE) \
    audio.a2dp.default \
    audio_policy.$(PRODUCT_DEVICE) \
    vibrator.$(PRODUCT_DEVICE)

# Graphics
PRODUCT_PACKAGES += \
    hwcomposer.$(PRODUCT_DEVICE) \
    libGLES_mesa    \
    gralloc.$(PRODUCT_DEVICE)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072 \
    ro.sf.lcd_density=240

# hw_ssl
#PRODUCT_PACKAGES += \
    libdx-crys \
    start-sep

# Bluetooth
PRODUCT_PACKAGES += \
    bt_ti

# Wifi
PRODUCT_PACKAGES += \
    wifi_ti

PRODUCT_PROPERTY_OVERRIDES += \
    net.eth0.ip=169.254.9.64 \
    net.eth0.netmask=255.255.0.0

# IPV6
PRODUCT_PACKAGES += \
    rdnssd \
    dhcp6c

COMMON_PATH := vendor/intel/common
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/ueventd.common.rc:root/ueventd.$(PRODUCT_DEVICE).rc

# This device is xhdpi.  However the platform doesn't
# currently contain all of the bitmaps at xhdpi density so
# we do this little trick to fall back to the hdpi version
# if the xhdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_PACKAGES += \
    watchdogd \
    libwatchdogd_devel

# usb accessory
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

#Enable MTP by default
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

ifeq ($(TARGET_BUILD_VARIANT),eng)
COMMON_GLOBAL_CFLAGS += -DLIBXML_THREAD_ENABLED -DLIBXML_TREE_ENABLED
endif


# Optional GMS applications
-include vendor/google/PRIVATE/gms/products/gms_optional.mk


# Intel Corp Email certificate
-include vendor/intel/PRIVATE/cert/IntelCorpEmailCert.mk

# Enable HOT SWAP
PRODUCT_PROPERTY_OVERRIDES += persist.tel.hot_swap.support=true

#enable Widevine drm
PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true

PRODUCT_PACKAGES += com.google.widevine.software.drm.xml \
    com.google.widevine.software.drm \
    libdrmwvmplugin \
    libwvm \
    libdrmdecrypt \
    libWVStreamControlAPI_L1 \
    libwvdrm_L1

ifeq ($(TARGET_BUILD_VARIANT),eng)
 PRODUCT_PACKAGES += \
     WidevineSamplePlayer
endif

# Board initrc file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.$(PRODUCT_DEVICE).rc:root/init.$(PRODUCT_DEVICE).rc \
#    $(LOCAL_PATH)/init.debug.rc:root/init.debug.rc \
#    $(LOCAL_PATH)/init.diag.rc:root/init.diag.rc \
#    $(LOCAL_PATH)/init.wireless.rc:root/init.wireless.rc \
#    $(LOCAL_PATH)/init.modem.rc:root/init.modem.rc \
#    $(LOCAL_PATH)/init.avc.rc:root/init.avc.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vold.fstab:system/etc/vold.fstab

#################################################"
# Include platform - do not inherit so that variables can be set before inclusion
include vendor/intel/baytrail/baytrail.mk
