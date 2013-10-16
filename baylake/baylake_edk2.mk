PRODUCT_NAME := baylake_edk2
REF_PRODUCT_NAME := baylake

BOARD_HAS_CAPSULE := false

FORCE_FLASHFILE_NO_OTA := true

TARGET_PARTITIONING_SCHEME := "full-gpt"
TARGET_BIOS_TYPE := "uefi"

# Disable SPID param in cmdline
USE_SPID := false

# Disable serialno param in cmdline
USE_BL_SERIALNO := true

# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

