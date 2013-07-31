PRODUCT_NAME := baylake_edk2
REF_PRODUCT_NAME := baylake

KERNEL_DIFFCONFIG := $(LOCAL_PATH)/$(PRODUCT_NAME)_diffconfig
BOARD_HAS_CAPSULE := false

FORCE_FLASHFILE_NO_OTA := true

# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

