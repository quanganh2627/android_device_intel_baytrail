PRODUCT_NAME := baylake_next
REF_PRODUCT_NAME := baylake

KERNEL_SRC_DIR := linux/kernel-next
BOARD_HAVE_KNEXT := true

include $(LOCAL_PATH)/baylakepath.mk

# Replace platform USB with "next" version - first found has precedence
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.byt_next.usb.rc:root/init.platform.usb.rc

# File init.baylake_next.gengfx.rc is being added before the other use
# of this destination, so it will have precedence.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.baylake_next.gengfx.rc:root/init.platform.gengfx.rc

# Include base product makefile
include $(LOCAL_PATH)/baylake.mk

