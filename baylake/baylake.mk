# Include base makefile
include $(LOCAL_PATH)/device.mk

LOCAL_PATH := $(TOP)/vendor/intel/baytrail/baylake

PRODUCT_NAME := baylake

# Crash Report / crashinfo
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    CrashReport \
    crashinfo \
    com.google.gson \
    com.google.gson.xml \
    logconfig \
    crashparsing \
    crashparsing.xml
endif
