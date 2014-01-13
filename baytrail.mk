# Superclass
include device/intel/common/common.mk

LOCAL_PATH := device/intel/baytrail

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.baytrail.rc:root/init.baytrail.rc \
	$(LOCAL_PATH)/init.recovery.baytrail.rc:root/init.recovery.baytrail.rc \
	$(LOCAL_PATH)/media_codecs.xml:system/etc/media_codecs.xml \
	$(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
	$(LOCAL_PATH)/camera_profiles.xml:system/etc/camera_profiles.xml \
	$(LOCAL_PATH)/thermal-conf.xml:system/etc/thermal-daemon/thermal-conf.xml

$(call inherit-mixin, cpu-arch, slm)

