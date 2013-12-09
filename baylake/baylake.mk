# Superclass
include device/intel/baytrail/baytrail.mk

PRODUCT_NAME := baylake
PRODUCT_DEVICE := baylake
PRODUCT_MODEL := Bay Lake

LOCAL_PATH := device/intel/baytrail/baylake

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.rc:root/init.$(TARGET_PRODUCT).rc \
	$(LOCAL_PATH)/init.recovery.rc:root/init.recovery.$(TARGET_PRODUCT).rc \

$(call inherit-mixin, audio, pc_alc262)
$(call inherit-mixin, gms, true)
$(call inherit-mixin, houdini, true)
$(call inherit-mixin, boot-arch, efi)
$(call inherit-mixin, graphics, ufo)
$(call inherit-mixin, ethernet, configurable)
$(call inherit-mixin, video, ufo)
$(call inherit-mixin, governor, interactive)
$(call inherit-mixin, liblights, intel)
$(call inherit-mixin, power, interactive_gov)
$(call inherit-mixin, navigationbar, true)

