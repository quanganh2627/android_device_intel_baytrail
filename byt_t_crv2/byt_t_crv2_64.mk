PRODUCT_NAME := byt_t_crv2_64
REF_PRODUCT_NAME := byt_t_crv2

BOARD_USE_64BIT_KERNEL := true

# Revert-me force OS loader polciy to fake until GetBatteryStatus
OSLOADER_EM_POLICY = fake

include $(LOCAL_PATH)/byt_t_crv2_path.mk

include $(LOCAL_PATH)/byt_t_crv2.mk

BOARD_HAS_CAPSULE := false
