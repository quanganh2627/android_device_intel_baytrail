include $(COMMON_PATH)/parameter-framework/AndroidBoard.mk

LOCAL_PATH := $(PLATFORM_PATH)/parameter-framework

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.bigcore
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.common \
    Realtek_RT5640Subsystem.xml \
    LPESubsystem.xml \
    LPEMixerSubsystem.xml
include $(BUILD_PHONY_PACKAGE)


##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := Realtek_RT5640Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := LPESubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := LPEMixerSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)





