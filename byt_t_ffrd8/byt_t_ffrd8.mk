# Superclass
include device/intel/baytrail/baytrail.mk

PRODUCT_NAME := byt_t_ffrd8
PRODUCT_DEVICE := byt_t_ffrd8
PRODUCT_MODEL := Baytrail FFRD8

LOCAL_PATH := device/intel/baytrail/byt_t_ffrd8

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.rc:root/init.$(TARGET_PRODUCT).rc \
	$(LOCAL_PATH)/init.recovery.rc:root/init.recovery.$(TARGET_PRODUCT).rc \

$(call inherit-mixin, gms, false)
$(call inherit-mixin, houdini, true)
$(call inherit-mixin, boot-arch, sfi)
$(call inherit-mixin, graphics, software)
$(call inherit-mixin, display-density, high)
$(call inherit-mixin, touch, max_1664S_8)

