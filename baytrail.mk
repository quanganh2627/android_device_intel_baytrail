# Superclass
include device/intel/common/common.mk

LOCAL_PATH := device/intel/baytrail

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.baytrail.rc:root/init.baytrail.rc \
	$(LOCAL_PATH)/init.recovery.baytrail.rc:root/init.recovery.baytrail.rc

$(call inherit-mixin, cpu-arch, slm)

