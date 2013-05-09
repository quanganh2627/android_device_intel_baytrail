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
$(call inherit-product, build/target/product/full_base_no_telephony.mk)
# Include Dalvik Heap Size Configuration
$(call inherit-product, vendor/intel/common/dalvik/phone-xhdpi-1024-dalvik-heap.mk)

# Overrides
PRODUCT_DEVICE := baylake
PRODUCT_MODEL := baylake

PRODUCT_CHARACTERISTICS := nosdcard,tablet

# intel common overlay folder
DEVICE_PACKAGE_OVERLAYS := vendor/intel/common/overlays

OVERRIDE_COPIES := \
    $(LOCAL_PATH)/asound.conf:system/etc/asound.conf \
    $(LOCAL_PATH)/init.baylake.sh:root/init.baylake.sh \
    $(LOCAL_PATH)/egl.cfg:system/lib/egl/egl.cfg \
    $(LOCAL_PATH)/init.net.eth0.sh:root/init.net.eth0.sh

# Make generic definetion of media components.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/wrs_omxil_components.list:system/etc/wrs_omxil_components.list \
    $(LOCAL_PATH)/mfx_omxil_core.conf:system/etc/mfx_omxil_core.conf \
    $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/sensors/sensor_hal_config_default.xml:system/etc/sensor_hal_config_default.xml

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

# libstagefrighthw
PRODUCT_PACKAGES += \
    libstagefrighthw

# Media SDK and OMX IL components
PRODUCT_PACKAGES += \
    libmfxhw32 \
    libmfx_omx_core \
    libmfx_omx_components_hw \
    libgabi++-mfx \
    libstlport-mfx

# omx components
PRODUCT_PACKAGES += \
    libwrs_omxil_core_pvwrapped \
    libOMXVideoDecoderAVC \
    libOMXVideoDecoderH263 \
    libOMXVideoDecoderMPEG4 \
    libOMXVideoDecoderWMV \
    libOMXVideoDecoderVP8 \
    libOMXVideoEncoderAVC

# libmix
PRODUCT_PACKAGES += \
    libmixvbp_mpeg4 \
    libmixvbp_h264 \
    libmixvbp_vc1 \
    libmixvbp_vp8

# libva
PRODUCT_PACKAGES += \
    vainfo \
    pvr_drv_video

PRODUCT_PACKAGES += \
    msvdx_fw_mfld_DE2.0.bin

# video encoder and camera
PRODUCT_PACKAGES += \
    libsharedbuffer

# video editor
PRODUCT_PACKAGES += \
    libI420colorconvert

# hardware HAL
PRODUCT_PACKAGES += \
    audio_hal_configurable \
    libaudioresample \
    libbluetooth-audio \
    mediabtservice \
    audio.a2dp.default \
    vibrator.$(PRODUCT_DEVICE) \
    audio.usb.default

# sensors
PRODUCT_PACKAGES += \
    sensors.$(PRODUCT_DEVICE)

# Graphics
PRODUCT_PACKAGES += \
    hwcomposer.$(PRODUCT_DEVICE) \
    libdrm_intel \
    ufo \
    ufo_test

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072 \
    ro.sf.lcd_density=220

# Intel fake multiple display
PRODUCT_PACKAGES += \
    com.intel.multidisplay \
    com.intel.multidisplay.xml

#widi audio HAL
PRODUCT_PACKAGES += \
audio.widi.$(PRODUCT_DEVICE)

#widi
PRODUCT_PACKAGES += \
   widi.conf \
   libwidiservice \
   libwidiclient \
   libwidimedia \
   libwidirtsp

# busybox
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    busybox
endif

# hw_ssl
#PRODUCT_PACKAGES += \
    libdx-crys \
    start-sep

# BCM4752 GPS
PRODUCT_PACKAGES += \
    gps_bcm_4752_extlna

# Bluetooth
PRODUCT_PACKAGES += \
    bt_bcm

# IPV6
PRODUCT_PACKAGES += \
    rdnssd \
    dhcp6c

# libmfldadvci
PRODUCT_PACKAGES += \
    libmfldadvci \
    dummy.cpf \
    CGamma_DIS5MP.bin \
    noise.fpn \
    Preview_UserParameter_imx135.prm \
    Primary_UserParameter_imx135.prm \
    Video_UserParameter_imx135.prm \
    YGamma_DIS5MP.bin \
    Mor_8MP_8BQ.txt

# libcamera
PRODUCT_PACKAGES += \
    camera.$(PRODUCT_DEVICE)

# IntelCamera Parameters extensions
PRODUCT_PACKAGES += \
    libintelcamera_jni \
    com.intel.camera.extensions \
    com.intel.camera.extensions.xml

# camera sensor tuning parameter
PRODUCT_PACKAGES += \
        libSh3aParamsimx135

# camera firmware
PRODUCT_PACKAGES += \
        shisp_2400.bin \
        shisp_2400b0.bin \
        shisp_2400b0_cssv2.bin

# video encoder and camera
PRODUCT_PACKAGES += \
        libsharedbuffer

# board specific files
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
        $(LOCAL_PATH)/camera_profiles.xml:system/etc/camera_profiles.xml

# audio policy file
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf


# Camera app
PRODUCT_PACKAGES += \
    IntelCamera

# Test Camera is for Test only
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PACKAGES += \
    TestCamera
endif


# Filesystem management tools
PRODUCT_PACKAGES += \
    e2fsck \
    setup_fs

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.touchscreen.multitouch.jazzhand.xml:$(PERMISSIONS_PATH)/android.hardware.touchscreen.multitouch.jazzhand.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.location.gps.xml:$(PERMISSIONS_PATH)/android.hardware.location.gps.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.camera.flash-autofocus.xml:$(PERMISSIONS_PATH)/android.hardware.camera.flash-autofocus.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.camera.front.xml:$(PERMISSIONS_PATH)/android.hardware.camera.front.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.accelerometer.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.accelerometer.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.barometer.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.barometer.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.compass.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.compass.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.gyroscope.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.gyroscope.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.light.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.light.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.usb.host.xml:$(PERMISSIONS_PATH)/android.hardware.usb.host.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.usb.accessory.xml:$(PERMISSIONS_PATH)/android.hardware.usb.accessory.xml \
    $(FRAMEWORK_ETC_PATH)/tablet_core_hardware.xml:$(PERMISSIONS_PATH)/tablet_core_hardware.xml
#   $(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

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

#NXP audio effects
PRODUCT_PACKAGES += \
    libbundlewrapper.so \
    libreverbwrapper.so \
    libxmlparser.so \
    LvmDefaultControlParams.xml \
    LvmSessionConfigurationMinus1.xml

# Optional GMS applications
-include vendor/google/PRIVATE/gms/products/gms_optional.mk


# Intel Corp Email certificate
-include vendor/intel/PRIVATE/cert/IntelCorpEmailCert.mk

# Enable ALAC
PRODUCT_PACKAGES += \
    libstagefright_soft_alacdec

# Enable HOT SWAP
PRODUCT_PROPERTY_OVERRIDES += persist.tel.hot_swap.support=true

# Intel VPP/FRC
PRODUCT_PACKAGES += \
    VppSettings

#audio firmware
AUDIO_FW_PATH := device/intel/fw/sst/
PRODUCT_COPY_FILES += \
    $(AUDIO_FW_PATH)/fw_sst_0f28.bin:system/etc/firmware/fw_sst_0f28.bin \

# Board initrc file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.$(PRODUCT_DEVICE).rc:root/init.$(PRODUCT_DEVICE).rc \
    $(LOCAL_PATH)/init.avc.rc:root/init.avc.rc
#    $(LOCAL_PATH)/init.diag.rc:root/init.diag.rc \
#    $(LOCAL_PATH)/init.wireless.rc:root/init.wireless.rc \
#    $(LOCAL_PATH)/init.modem.rc:root/init.modem.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vold.fstab:system/etc/vold.fstab

#################################################"
# Include platform - do not inherit so that variables can be set before inclusion
include vendor/intel/baytrail/baytrail.mk
