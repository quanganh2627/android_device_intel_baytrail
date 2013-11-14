# parameter-framework
DEVICE_PATH := $(call my-dir)
PLATFORM_PATH := $(DEVICE_PATH)/..
COMMON_PATH := $(PLATFORM_PATH)/../common

include $(PLATFORM_PATH)/AndroidBoard.mk

#Include device specific parameter framework settings
include $(DEVICE_PATH)/parameter-framework/AndroidBoard.mk
