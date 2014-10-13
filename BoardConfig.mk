
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

ifneq ($(TARGET_NO_RECOVERY),true)
TARGET_RECOVERY_UI_LIB := libintel_recovery_ui
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_UPDATER_LIBS += libintel_updater
endif

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
ifeq ($(TARGET_USE_DROIDBOOT),true)
TARGET_DROIDBOOT_LIBS := libintel_droidboot
TARGET_DROIDBOOT_USB_MODE_FASTBOOT := true
TARGET_RELEASETOOLS_EXTENSIONS := $(PLATFORM_PATH)
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/recovery.fstab
DROIDBOOT_USE_INSTALLER := true
endif

ifeq ($(TARGET_DROIDBOOT_USB_MODE_FASTBOOT),true)
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE += g_android.fastboot=1 droidboot.minbatt=1
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

# Force default camera pixel format to HAL_PIXEL_FORMAT_YCbCr_422_I to properly
# display YUYV format for camera preview when using HAL3
TARGET_CAMERA_PIXEL_FORMAT := HAL_PIXEL_FORMAT_YCbCr_422_I

BOARD_SEPOLICY_DIRS :=\
        device/intel/baytrail/sepolicy
BOARD_SEPOLICY_REPLACE := \
        app.te \
        domain.te
BOARD_SEPOLICY_UNION :=\
        coreu.te \
        dumpstate.te \
        ecryptfs.te \
        file_contexts \
        file.te \
        fs_use \
        genfs_contexts \
        gpsd.te \
        hdcpd.te \
        healthd.te \
        init_shell.te \
        init.te \
        isolated_app.te \
        kernel.te \
        keystore.te \
        mediaserver.te \
        mmgr.te \
        netd.te \
        nvm_server.te \
        radio.te \
        rild.te \
        seapp_contexts \
        sensorhubd.te \
        service.te \
        service_contexts \
        servicemanager.te \
        surfaceflinger.te \
        system_app.te \
        system_server.te \
        untrusted_app.te \
        vdc.te \
        vold.te \
        wpa.te \
        zygote.te

# DRM Protected Video
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
