PRODUCT_NAME := byt_t_ffrd8_edk2
REF_PRODUCT_NAME := byt_t_ffrd8

BOARD_HAS_CAPSULE := true
FORCE_FLASHFILE_NO_OTA := true
TARGET_OS_SIGNING_METHOD := isu
TARGET_PARTITIONING_SCHEME := "full-gpt"
TARGET_BIOS_TYPE := "uefi"
HAS_SPINOR := true
USE_FPT := true

include $(LOCAL_PATH)/byt_t_ffrd8.mk

