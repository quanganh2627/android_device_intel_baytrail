include device/intel/baytrail/BoardConfig.mk

TARGET_USE_MOKMANAGER := true

# Note, Iago installer also sets androidboot.disk via bootloader
# config, if Iago not used you will need to add
# androidboot.disk=pci0000:00/0000:00:13.0
BOARD_KERNEL_CMDLINE += \
		androidboot.sdcard=sdb

# Releasetools extensions for updating EFI System Partition and
# userfastboot (if present). Product teams will need to copy this
# file and make their own changes to it if they have additional
# OTA tasks; there currently can only be one of these.
TARGET_RELEASETOOLS_EXTENSIONS := device/intel/common/releasetools/releasetools-generic-efi.py

