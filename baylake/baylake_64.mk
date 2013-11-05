PRODUCT_NAME := baylake_64
REF_PRODUCT_NAME := baylake

BOARD_USE_64BIT_KERNEL := true

KERNEL_SRC_DIR := linux/kernel

include $(LOCAL_PATH)/baylakepath.mk

# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

