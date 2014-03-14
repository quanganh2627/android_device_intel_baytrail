include $(PLATFORM_CONF_PATH)/parameter-framework/AndroidBoard.mk

LOCAL_PATH := $(DEVICE_CONF_PATH)/parameter-framework

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.anzhen4_mrd7
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.anzhen4_mrd7.nodomains \
    AudioConfigurableDomains.xml
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.anzhen4_mrd7.nodomains
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.audio.baytrail \
    SysfsPmdownTimeBytcrSubsystem.xml \
    TI_TLV320AIC3100Subsystem.xml \
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


include $(CLEAR_VARS)
LOCAL_MODULE := TI_TLV320AIC3100Subsystem.xml
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
        parameter-framework.audio.anzhen4_mrd7.nodomains
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): MY_SRC_FILES := \
        $(TARGET_OUT_ETC)/parameter-framework/ParameterFrameworkConfiguration.xml \
        $(LOCAL_PATH)/criteria.txt \
        $(LOCAL_PATH)/XML/Settings/Audio/AudioConfigurableDomains.xml \
        $(LOCAL_PATH)/XML/Settings/Audio/anzhen4_mrd7_routing_tlv320aic3100.pfw

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


##################################################
# PACKAGE : parameter-framework.vibrator.baytrail

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.vibrator.anzhen4_mrd7
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    parameter-framework.vibrator.common \
    SysfsVibratorClass.xml \
    SysfsVibratorSubsystem.xml \
    VibratorConfigurableDomains.xml

ifeq ($(TARGET_BUILD_VARIANT),eng)
LOCAL_REQUIRED_MODULES += ParameterFrameworkConfigurationVibrator.xml
else
LOCAL_REQUIRED_MODULES += ParameterFrameworkConfigurationVibratorNoTuning.xml
endif

include $(BUILD_PHONY_PACKAGE)

##################################################
# MODULES REQUIRED by parameter-framework.vibrator.baytrail Package

include $(CLEAR_VARS)
LOCAL_MODULE := SysfsVibratorClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Vibrator
LOCAL_SRC_FILES := XML/Structure/Vibrator/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SysfsVibratorSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Structure/Vibrator
LOCAL_SRC_FILES := XML/Structure/Vibrator/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VibratorConfigurableDomains.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework/Settings/Vibrator
LOCAL_SRC_FILES := XML/Settings/Vibrator/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

ifeq ($(TARGET_BUILD_VARIANT),eng)

# Engineering build: Tuning allowed

include $(CLEAR_VARS)
LOCAL_MODULE := ParameterFrameworkConfigurationVibrator.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework
LOCAL_SRC_FILES := XML/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

else

# Userdebug build: NoTuning allowed

include $(CLEAR_VARS)
LOCAL_MODULE := ParameterFrameworkConfigurationVibratorNoTuning.xml
LOCAL_MODULE_STEM := ParameterFrameworkConfigurationVibrator.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/parameter-framework
LOCAL_SRC_FILES := XML/ParameterFrameworkConfigurationVibratorNoTuning.xml
include $(BUILD_PREBUILT)

endif
