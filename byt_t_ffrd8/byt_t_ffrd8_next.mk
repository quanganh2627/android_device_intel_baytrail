PRODUCT_NAME := byt_t_ffrd8_next
REF_PRODUCT_NAME := byt_t_ffrd8

KERNEL_SRC_DIR := linux/kernel-next
BOARD_HAVE_KNEXT := true

include $(LOCAL_PATH)/byt_t_ffrd8_path.mk

# Replace platform USB with "next" version - first found has precedence
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/init.byt_next.usb.rc:root/init.platform.usb.rc

# File init.byt_t_ffrd8_next.gengfx.rc is being added before the other use
# of this destination, so it will have precedence.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.byt_t_ffrd8_next.gengfx.rc:root/init.platform.gengfx.rc

include $(LOCAL_PATH)/byt_t_ffrd8.mk
