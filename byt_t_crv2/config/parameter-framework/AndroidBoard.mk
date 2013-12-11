include $(PLATFORM_CONF_PATH)/parameter-framework/AndroidBoard.mk

LOCAL_PATH := $(DEVICE_CONF_PATH)/parameter-framework

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.byt_t_crv2
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.byt_t_crv2.nodomains \
    AudioConfigurableDomains.xml
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.byt_t_crv2.nodomains
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.baytrail \
    parameter-framework.audio.imc.subsystem \
    parameter-framework.audio.pmdown_time.subsystem \
    AudioClass.xml

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
        parameter-framework.audio.byt_t_crv2.nodomains
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): MY_SRC_FILES := \
        $(TARGET_OUT_ETC)/parameter-framework/ParameterFrameworkConfiguration.xml \
        $(LOCAL_PATH)/criteria.txt \
        $(LOCAL_PATH)/XML/Settings/Audio/AudioConfigurableDomains.xml \
        $(LOCAL_PATH)/XML/Settings/Audio/byt_t_crv2_routing_realtek5640.pfw \
        $(LOCAL_PATH)/XML/Settings/Audio/byt_t_crv2_routing_xmm.pfw

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
