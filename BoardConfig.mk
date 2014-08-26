
include device/intel/common/BoardConfig.mk

TARGET_ARCH_VARIANT := silvermont

ifeq ($(FORCE_FLASHFILE_NO_OTA),true)
  FLASHFILE_NO_OTA := true
else
  FLASHFILE_NO_OTA := false
endif

BOARD_HAS_CAPSULE ?= true

# For Baytrail appends the path to EGL libraries.
PRODUCT_LIBRARY_PATH := $(PRODUCT_LIBRARY_PATH):/system/lib/egl

# Disable recovery for now
ifeq ($(TARGET_USE_USERFASTBOOT),true)
TARGET_MAKE_NO_DEFAULT_RECOVERY := false
else
TARGET_MAKE_NO_DEFAULT_RECOVERY := true
endif
TARGET_NO_RECOVERY := false

ENABLE_GEN_GRAPHICS := true

# RenderScript Properties
# debug.rs.default-CPU-driver 1: force on CPU, 0 (default): use props as below:
# debug.rs.dev.scripts      cpu: run rs/fs on CPU,     gpu: run rs/fs on GPGPU
# debug.rs.dev.intrinsics   cpu: run intrinsic on CPU  gpu: on GPGPU
ifneq (,$(filter $(TARGET_BUILD_VARIANT),eng userdebug))
ADDITIONAL_BUILD_PROPERTIES += \
    debug.rs.dev.scripts=gpu \
    debug.rs.dev.intrinsics=gpu
endif

ifneq ($(TARGET_USE_USERFASTBOOT),true)
ifneq ($(TARGET_NO_RECOVERY),true)
TARGET_RECOVERY_UI_LIB := libintel_recovery_ui
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_UPDATER_LIBS += libintel_updater
endif
endif

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
ifeq ($(TARGET_USE_DROIDBOOT),true)
TARGET_DROIDBOOT_LIBS := libintel_droidboot
TARGET_DROIDBOOT_USB_MODE_FASTBOOT := true
TARGET_MAKE_NO_DEFAULT_OTA_PACKAGE := true
TARGET_RELEASETOOLS_EXTENSIONS := $(HOST_OUT)/bin/releasetools.py
OTA_FROM_TARGET_FILES := $(HOST_OUT)/bin/ota_from_target_files
DROIDBOOT_USE_INSTALLER := true
endif

ifeq ($(TARGET_DROIDBOOT_USB_MODE_FASTBOOT),true)
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE += g_android.fastboot=1 droidboot.minbatt=0
endif

ifneq ($(DROIDBOOT_SCRATCH_SIZE),)
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE += droidboot.scratch=$(DROIDBOOT_SCRATCH_SIZE)
endif

# enable libsensorhub
ENABLE_SENSOR_HUB := true

# enable scalable sensor HAL
ENABLE_SCALABLE_SENSOR_HAL := true

# Software MPEG4 encoder
SW_MPEG4_ENCODER := true

cmdline_extra += oops=panic panic=40

# Dalvik
DEFAULT_JIT_CODE_GENERATOR := PCG

# Security
BUILD_WITH_SECURITY_FRAMEWORK := txei

# enable WebRTC
ENABLE_WEBRTC := false

INTEL_FEATURE_ARKHAM := false
ifeq ($(INTEL_FEATURE_ARKHAM),true)
PRODUCT_BOOT_JARS := $(PRODUCT_BOOT_JARS):com.intel.arkham.services
endif

ifeq ($(strip $(INTEL_FEATURE_ARKHAM)),true)
ADDITIONAL_BUILD_PROPERTIES += \
ro.intel.arkham.enabled=true \
ro.intel.arkham.maxcontainers=1
endif

#BOARD_SEPOLICY_DIRS :=\
	device/intel/baytrail/sepolicy

#BOARD_SEPOLICY_UNION :=\
	file_contexts \
	seapp_contexts \
	file.te \
	genfs_contexts \
	fs_use \
	device.te \
	healthd.te \
	app.te \
	untrusted_app.te \
	surfaceflinger.te \
	vold.te \
	ecryptfs.te \
	zygote.te \
	netd.te
