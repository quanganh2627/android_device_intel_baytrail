include $(PLATFORM_CONF_PATH)/parameter-framework/AndroidBoard.mk

LOCAL_PATH := $(DEVICE_CONF_PATH)/parameter-framework

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.catalog_dev
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.catalog_dev.nodomains \
    AudioConfigurableDomains.xml
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.catalog_dev.nodomains
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.baytrail \
    SysfsPmdownTimeBytcrSubsystem.xml \
    AudioClass.xml

ifeq ($(BOARD_USES_CODEC), TI31XX)
LOCAL_REQUIRED_MODULES += TI_TLV320AIC3100Subsystem.xml
endif
ifeq ($(BOARD_USES_CODEC), RT5645)
LOCAL_REQUIRED_MODULES += Realtek_RT5645Subsystem.xml
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
LOCAL_REQUIRED_MODULES += ParameterFrameworkConfiguration.xml
else
LOCAL_REQUIRED_MODULES += ParameterFrameworkConfigurationNoTuning.xml
endif

include $(BUILD_PHONY_PACKAGE)


##################################################


include $(CLEAR_VARS)
LOCAL_MODULE := AudioClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
ifeq ($(BOARD_USES_CODEC), TI31XX)
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
endif
ifeq ($(BOARD_USES_CODEC), RT5645)
LOCAL_SRC_FILES := XML/Structure/Audio/AudioClass_RT5645.xml
endif
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := TI_TLV320AIC3100Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Realtek_RT5645Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)



include $(CLEAR_VARS)
LOCAL_MODULE := SysfsPmdownTimeBytcrSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Audio
LOCAL_SRC_FILES := XML/Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

ifeq ($(BOARD_USES_AUDIO_HAL_CONFIGURABLE),true)

## Audio Tuning + Routing

include $(CLEAR_VARS)
LOCAL_MODULE := AudioConfigurableDomains.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Settings/Audio

LOCAL_REQUIRED_MODULES := \
        hostDomainGenerator.sh \
        parameter-framework.audio.catalog_dev.nodomains
include $(BUILD_SYSTEM)/base_rules.mk

ifeq ($(BOARD_USES_CODEC), TI31XX)
$(LOCAL_BUILT_MODULE): MY_SRC_FILES := \
        $(TARGET_OUT_ETC)/parameter-framework/ParameterFrameworkConfiguration.xml \
        $(LOCAL_PATH)/criteria.txt \
        $(LOCAL_PATH)/XML/Settings/Audio/AudioConfigurableDomains.xml \
        $(LOCAL_PATH)/XML/Settings/Audio/catalog_dev_routing_tlv320aic3100.pfw
endif

ifeq ($(BOARD_USES_CODEC), RT5645)
$(LOCAL_BUILT_MODULE): MY_SRC_FILES := \
        $(TARGET_OUT_ETC)/parameter-framework/ParameterFrameworkConfiguration.xml \
        $(LOCAL_PATH)/criteria.txt \
        $(LOCAL_PATH)/XML/Settings/Audio/AudioConfigurableDomains_RT5645.xml \
        $(LOCAL_PATH)/XML/Settings/Audio/catalog_dev_routing_rt5645.pfw
endif

$(LOCAL_BUILT_MODULE): $(LOCAL_REQUIRED_MODULES)
	$(hide) mkdir -p $(dir $@)
	bash hostDomainGenerator.sh $(MY_SRC_FILES) > $@

else

## Audio Tuning only

include $(CLEAR_VARS)
LOCAL_MODULE := AudioConfigurableDomains.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Settings/Audio
LOCAL_SRC_FILES := XML/Settings/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

endif

##################################################

ifeq ($(TARGET_BUILD_VARIANT),eng)

### Engineering build: Tuning allowed

# baylake
include $(CLEAR_VARS)
LOCAL_MODULE := ParameterFrameworkConfiguration.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework
LOCAL_SRC_FILES := XML/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

else

### Userdebug build: NoTuning allowed


# baytrail
include $(CLEAR_VARS)
LOCAL_MODULE := ParameterFrameworkConfigurationNoTuning.xml
LOCAL_MODULE_STEM := ParameterFrameworkConfiguration.xml
LOCAL_SRC_FILES := XML/ParameterFrameworkConfigurationNoTuning.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework
include $(BUILD_PREBUILT)

endif

