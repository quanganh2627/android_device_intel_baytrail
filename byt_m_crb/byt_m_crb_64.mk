PRODUCT_NAME := byt_m_crb_64
REF_PRODUCT_NAME := byt_m_crb

BOARD_USE_64BIT_KERNEL := true

include $(LOCAL_PATH)/has_uefi.mk

include $(LOCAL_PATH)/byt_m_crb_path.mk

include $(LOCAL_PATH)/byt_m_crb.mk
