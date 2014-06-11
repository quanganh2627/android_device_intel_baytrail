PRODUCT_NAME := catalog_dev_64
REF_PRODUCT_NAME := byt_t_crv2

BOARD_USE_64BIT_KERNEL := true

include $(LOCAL_PATH)/catalog_dev_path.mk

# Dongle files
PRODUCT_COPY_FILES += \
		$(LOCAL_PATH)/dongle/connect-chat:system/etc/ppp/connect-chat \
		$(LOCAL_PATH)/dongle/ip-up:system/etc/ppp/ip-up \
		$(LOCAL_PATH)/dongle/ip-down:system/etc/ppp/ip-down \
		$(LOCAL_PATH)/dongle/chat:system/xbin/chat \
		$(LOCAL_PATH)/dongle/usb_modeswitch:system/xbin/usb_modeswitch

#Add 3G Dongle
PRODUCT_PACKAGES += \
   Dongle

include $(LOCAL_PATH)/catalog_dev.mk
