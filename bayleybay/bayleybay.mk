# Superclass
include device/intel/baytrail/baytrail.mk

PRODUCT_NAME := bayleybay
PRODUCT_DEVICE := bayleybay
PRODUCT_MODEL := Bayley Bay

LOCAL_PATH := device/intel/baytrail/bayleybay

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.rc:root/init.$(TARGET_PRODUCT).rc \
	$(LOCAL_PATH)/init.recovery.rc:root/init.recovery.$(TARGET_PRODUCT).rc \

$(call inherit-mixin, audio, byt_alc262)
$(call inherit-mixin, gms, true)
$(call inherit-mixin, houdini, true)
$(call inherit-mixin, boot-arch, efi)
$(call inherit-mixin, graphics, ufo)
$(call inherit-mixin, ethernet, configurable)
$(call inherit-mixin, fastboot, userfastboot)
$(call inherit-mixin, video, ufo)
$(call inherit-mixin, governor, interactive)
$(call inherit-mixin, liblights, intel)
$(call inherit-mixin, power, interactive_gov)
$(call inherit-mixin, navigationbar, true)
$(call inherit-mixin, camera-usb, usb)
$(call inherit-mixin, storage, 1xSD_3xUSB)
$(call inherit-mixin, bluetooth, intel)
