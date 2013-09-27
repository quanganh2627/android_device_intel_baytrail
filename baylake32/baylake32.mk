# Superclass
include device/intel/baytrail/baytrail.mk

PRODUCT_NAME := baylake32
PRODUCT_DEVICE := baylake32
PRODUCT_MODEL := Bay Lake (32-bit BIOS)

LOCAL_PATH := device/intel/baytrail/baylake32

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.rc:root/init.$(TARGET_PRODUCT).rc \
	$(LOCAL_PATH)/init.recovery.rc:root/init.recovery.$(TARGET_PRODUCT).rc \

$(call inherit-mixin, gms, true)
$(call inherit-mixin, houdini, true)
$(call inherit-mixin, boot-arch, efi)
$(call inherit-mixin, graphics, mesa)
$(call inherit-mixin, ethernet, static)
$(call inherit-mixin, fastboot, userfastboot)

