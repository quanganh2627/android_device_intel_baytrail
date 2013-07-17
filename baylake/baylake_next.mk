PRODUCT_NAME := baylake_next
REF_PRODUCT_NAME := baylake

KERNEL_SRC_DIR := linux/kernel-next

DROIDBOOT_NO_GUI := true
include $(LOCAL_PATH)/baylakepath.mk

# Replace platform USB with "next" version - first found has precedence
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.byt_next.usb.rc:root/init.platform.usb.rc

# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

