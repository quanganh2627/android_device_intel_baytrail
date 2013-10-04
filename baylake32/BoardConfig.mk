include device/intel/baytrail/BoardConfig.mk

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 805306368

TARGET_USE_MOKMANAGER := true
TARGET_IAGO_DEFAULT_INI := device/intel/baytrail/baylake/iago-default.ini
TARGET_KERNEL_ARCH := i386
TARGET_KERNEL_CONFIG := $(TARGET_KERNEL_ARCH)_bigcore_android_defconfig

# Note, Iago installer also sets androidboot.disk via bootloader
# config, if Iago not used you will need to add
# androidboot.disk=80860F14:00
BOARD_KERNEL_CMDLINE += \
		androidboot.sdcard=mmcblk1

# Releasetools extensions for updating EFI System Partition and
# userfastboot (if present). Product teams will need to copy this
# file and make their own changes to it if they have additional
# OTA tasks; there currently can only be one of these.
TARGET_RELEASETOOLS_EXTENSIONS := device/intel/common/releasetools/releasetools-generic-efi.py

