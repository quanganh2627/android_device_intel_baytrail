PRODUCT_NAME := baylake_next
REF_PRODUCT_NAME := baylake

KERNEL_SRC_DIR := linux/kernel-next
BOARD_HAVE_KNEXT := true

include $(LOCAL_PATH)/baylakepath.mk


# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

