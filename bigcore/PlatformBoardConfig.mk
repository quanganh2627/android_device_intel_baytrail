
include device/intel/common/BoardConfig.mk


# Disable recovery for now
TARGET_MAKE_NO_DEFAULT_RECOVERY := true
TARGET_NO_RECOVERY := false

BOARD_SKIP_NVM := false

ENABLE_GEN_GRAPHICS := true

ifneq ($(TARGET_NO_RECOVERY),true)
TARGET_RECOVERY_UI_LIB := libintel_recovery_ui
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_UPDATER_LIBS += libintel_updater
TARGET_RECOVERY_UPDATER_EXTRA_LIBS := libcmfwdl
endif

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
ifeq ($(TARGET_USE_DROIDBOOT),true)
TARGET_DROIDBOOT_LIBS := libintel_droidboot
TARGET_DROIDBOOT_EXTRA_LIBS := libcmfwdl libminzip
TARGET_DROIDBOOT_USB_MODE_FASTBOOT := true
TARGET_MAKE_NO_DEFAULT_OTA_PACKAGE := true
TARGET_RELEASETOOLS_EXTENSIONS := $(HOST_OUT)/bin/releasetools.py
OTA_FROM_TARGET_FILES := $(HOST_OUT)/bin/ota_from_target_files
# Size in megabytes of Droidboot USB buffer, must be as large
# as the largest image we need to flash
DROIDBOOT_SCRATCH_SIZE := 100
endif

ifeq ($(TARGET_DROIDBOOT_USB_MODE_FASTBOOT),true)
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE += g_android.fastboot=1 droidboot.minbatt=0
endif

ifneq ($(DROIDBOOT_SCRATCH_SIZE),)
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE += droidboot.scratch=$(DROIDBOOT_SCRATCH_SIZE)
endif

# enable libsensorhub
ENABLE_SENSOR_HUB := true
