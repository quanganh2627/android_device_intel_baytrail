# Superclass
include device/intel/baytrail/baytrail.mk

PRODUCT_NAME := bayleybay
PRODUCT_DEVICE := bayleybay

LOCAL_PATH := device/intel/baytrail/bayleybay

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.$(TARGET_PRODUCT).rc:root/init.$(TARGET_PRODUCT).rc \
	$(LOCAL_PATH)/init.recovery.$(TARGET_PRODUCT).rc:root/init.recovery.$(TARGET_PRODUCT).rc \

$(call inherit-mixin, gms, true)
$(call inherit-mixin, houdini, true)
$(call inherit-mixin, boot-arch, efi)
$(call inherit-mixin, graphics, mesa)
$(call inherit-mixin, ethernet, static)

