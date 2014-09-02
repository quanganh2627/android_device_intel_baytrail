PRODUCT_NAME := anzhen4_mrd7_w_64
#REF_PRODUCT_NAME := byt_t_crv2

#3G dongle support: if true, Modem + dongle Co-exist; otherwise, only support modem,no support 3g dongle
SUPPORT_3G_DONGLE := true

ifeq ($(SUPPORT_3G_DONGLE),true)
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
endif

BOARD_USE_64BIT_KERNEL := true

include $(LOCAL_PATH)/anzhen4_mrd7_w_path.mk

include $(LOCAL_PATH)/anzhen4_mrd7_w.mk
