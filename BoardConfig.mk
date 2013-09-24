# Common BoardConfig options for any device that has
# a Bay Trail SoC

include device/intel/common/BoardConfig.mk

TARGET_BOARD_PLATFORM := baytrail

ifeq ($(ANDROID_CONSOLE),usb)
BOARD_CONSOLE_DEVICE := ttyUSB0,115200n8
else ifeq ($(ANDROID_CONSOLE),serial)
BOARD_CONSOLE_DEVICE := ttyS0,115200n8
else
BOARD_CONSOLE_DEVICE := tty0
endif

BOARD_KERNEL_CMDLINE += console=$(BOARD_CONSOLE_DEVICE)

TARGET_KERNEL_SOURCE := linux/kernel-uefi
TARGET_KERNEL_ARCH := x86_64
TARGET_KERNEL_CONFIG := $(TARGET_KERNEL_ARCH)_bigcore_android_defconfig

TARGET_IAGO_INI := device/intel/baytrail/iago.ini

