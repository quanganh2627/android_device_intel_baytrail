include device/intel/baytrail/BoardConfig.mk

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648

TARGET_KERNEL_SOURCE := linux/kernel
TARGET_KERNEL_ARCH := i386
TARGET_KERNEL_CONFIG := $(TARGET_KERNEL_ARCH)_byt_defconfig

# Note, Iago installer also sets androidboot.disk via bootloader
# config, if Iago not used you will need to add
# androidboot.disk=80860F14:00
BOARD_KERNEL_CMDLINE += \
		androidboot.sdcard=mmcblk1 \
		androidboot.disk=pci0000:00/0000:00:17.0

# Display and backlight Setting for Kernel
BOARD_KERNEL_CMDLINE += i915.mipi_panel_id=3 i915.i915_rotation=1 \
                        acpi_backlight=vendor
