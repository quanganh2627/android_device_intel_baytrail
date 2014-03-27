# Name of the reference design
# Should be changed with the original values when starting customization
REF_DEVICE_NAME ?= $(TARGET_DEVICE)
REF_PRODUCT_NAME ?= $(TARGET_PRODUCT)

# XXX what uses this?
TARGET_USE_GUMMIBOOT := true

STORAGE_CFLAGS := -DSTORAGE_BASE_PATH=\"/dev/block/sda\" -DSTORAGE_PARTITION_FORMAT=\"%s%d\"

# serialno
USE_BL_SERIALNO := true

# Android Security Framework
# must be set before include PLATFORM/BoardConfig.mk
INTEL_FEATURE_ASF := true
# Supported ASF Version
PLATFORM_ASF_VERSION := 1

include $(PLATFORM_PATH)/BoardConfig.mk

# -- Droidboot Defines --
TARGET_USE_USERFASTBOOT := true
# Policy here is to not stage it in production builds
ifneq ($(TARGET_BUILD_VARIANT),user)
TARGET_STAGE_USERFASTBOOT := true
else
TARGET_STAGE_USERFASTBOOT := false
endif
TARGET_DROIDBOOT_LIBS := libdbadbd libdbupdate
DROIDBOOT_HARDWARE_INITRC := $(DEVICE_PATH)/init.recovery.rc
DROIDBOOT_SCRATCH_SIZE := 1000
TARGET_BOOTLOADER_BOARD_NAME := byt_m_crb

# EFI targets use standard Android recovery and boot images
# Override a bunch of stuff set in superclass
TARGET_MAKE_NO_DEFAULT_RECOVERY := false
TARGET_MAKE_NO_DEFAULT_OTA_PACKAGE := false
TARGET_MAKE_NO_DEFAULT_BOOTIMAGE := false
TARGET_BOOTIMAGE_USE_EXT2 := false

TARGET_RECOVERY_UI_LIB := libbigcore_recovery_ui

# For recovery console minui
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"

# Addional Edify command implementations
TARGET_RECOVERY_UPDATER_LIBS += libbigcore_updater

# Extra libraries needed to be rolled into recovery updater
TARGET_RECOVERY_UPDATER_EXTRA_LIBS := libgpt_static

# Python extensions to build/tools/releasetools for constructing
# OTA Update packages
TARGET_RELEASETOOLS_EXTENSIONS := device/intel/baytrail/byt_m_crb/recovery/releasetools.py

# Add EFI apps to the target-files-package
TARGET_EFI_APPS := $(PRODUCT_OUT)/efi/gummiboot.efi $(PRODUCT_OUT)/efi/shim.efi
INSTALLED_RADIOIMAGE_TARGET := $(TARGET_EFI_APPS)

# This is a restricted boot device; users will not be able to enroll their own keys
TARGET_USE_MOKMANAGER := false

# Disable sparse build until we move to B-2 and re-use ethernet PCI card
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# IAFW component to build for this board
BOARD_IAFW_COMPONENT := brd_bayleybay

#Platform
BOARD_USES_48000_AUDIO_CAPTURE_SAMPLERATE_FOR_WIDI := true

# Connectivity
ifeq (, $(filter %_next, $(TARGET_PRODUCT)))
BOARD_HAVE_WIFI := true
BOARD_HAVE_BLUETOOTH := true
FLASHFILE_NO_OTA := false
else
#disable BT for kernel_next bringup
BOARD_HAVE_WIFI := true
BOARD_HAVE_BLUETOOTH := false
FLASHFILE_NO_OTA := true
endif

# Connectivity
BOARD_HAVE_MODEM := false
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_CONF_PATH)
TARGET_HAS_VPP := true
TARGET_VPP_USE_GEN := true
COMMON_GLOBAL_CFLAGS += -DGFX_BUF_EXT
# MultiDisplay service
TARGET_HAS_MULTIPLE_DISPLAY := true
#USE_MDS_LEGACY := true

USE_INTEL_IPP := true

# Power_HAL
POWERHAL_BYT := true

# Widi
INTEL_WIDI := true
INTEL_WIDI_BAYTRAIL := true
#INTEL_WIDI_BAYTRAIL := false

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_TINY_ALSA_AUDIO := true
BOARD_USES_AUDIO_HAL_CONFIGURABLE := true
BOARD_USE_VIBRATOR := true
BUILD_WITH_ALSA_UTILS := true
BOARD_USES_GENERIC_AUDIO := false

#GEN is one graphic and video engine
# Baytrail uses the GEN for the graphic and video
BOARD_GRAPHIC_IS_GEN := true

# Camera
# Set USE_CAMERA_STUB to 'true' for Fake Camera builds,
# 'false' for libcamera builds to use Camera Imaging(CI) supported by intel.
USE_CAMERA_STUB := false
USE_CAMERA_HAL2 := false
USE_CAMERA_USB := true

USE_INTEL_METABUFFER := true

USE_CSS_2_0 := true

# Enabled HW accelerated JPEG encoder using VA API
USE_INTEL_JPEG := false
# Enabled NXP Premium Audio Effect Libraries
#USE_INTEL_LVSE := true

ifeq ($(BOARD_KERNEL_CMDLINE),)
ifeq ($(TARGET_BUILD_VARIANT),eng)
BOARD_KERNEL_CMDLINE := console=ttyS0,115200 console=logk0 earlyprintk=nologger loglevel=8 drm.debug=0x0 hpet=disable kmemleak=off ptrace.ptrace_can_access=1 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra) nmi_watchdog=panic softlockup_panic=1 vmalloc=172M crashkernel=64M@256M
else ifeq ($(TARGET_BUILD_VARIANT),userdebug)
BOARD_KERNEL_CMDLINE := console=ttyS0,115200 console=logk0 earlyprintk=nologger loglevel=4 hpet=disable kmemleak=off ptrace.ptrace_can_access=1 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra) nmi_watchdog=panic softlockup_panic=1 vmalloc=172M
else
BOARD_KERNEL_CMDLINE := earlyprintk=nologger loglevel=0 hpet=disable kmemleak=off androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra) vmalloc=172M
endif
endif

ifeq ($(TARGET_KERNEL_ARCH),)
TARGET_KERNEL_ARCH := i386
endif

# Allow creation of iago live USB/CD images
TARGET_USE_IAGO := true
TARGET_IAGO_INI := $(DEVICE_PATH)/iago.ini
ifneq ($(TARGET_STAGE_USERFASTBOOT),true)
TARGET_IAGO_INI += $(DEVICE_PATH)/iago.nofastboot.ini
endif
TARGET_IAGO_DEFAULT_INI := $(DEVICE_PATH)/iago-default.ini

# Graphics
USE_OPENGL_RENDERER := true
BOARD_KERNEL_CMDLINE += vga=current i915.modeset=1 drm.vblankoffdelay=1 \
                        acpi_backlight=vendor

BOARD_USES_LIBPSS := false

INTEL_VA:=true
USE_INTEL_VA:=true
BOARD_USES_WRS_OMXIL_CORE:=true
BOARD_USES_MRST_OMX:=true
USE_INTEL_ASF_EXTRACTOR:=true
# enabled to use Intel secure AVC Stagefright HW decoder
USE_INTEL_SECURE_AVC := true
# enabled to use hardware VP8 decoder
USE_HW_VP8 := true

BOARD_USE_LIBVA_INTEL_DRIVER := true
BOARD_USE_LIBVA := true
BOARD_USE_LIBMIX := true

#Support background music playback for Widi Multitasking
ENABLE_BACKGROUND_MUSIC := true

# Settings for the Media SDK library and plug-ins:
# - USE_MEDIASDK: use Media SDK support or not
# - MFX_IPP: sets IPP library optimization to use
USE_MEDIASDK := true
# Enable CIP Codecs
USE_INTEL_MDP := true
MFX_IPP := p8
# enabled to use Intel audio SRC (sample rate conversion)
USE_INTEL_SRC := true
# enabled to use ALAC
USE_FEATURE_ALAC := true

# Defines Intel library for GPU accelerated Renderscript:
OVERRIDE_RS_DRIVER := libRSDriver_intel7.so

#Camera
ADDITIONAL_BUILD_PROPERTIES += \
				ro.camera.number=1 \
				ro.camera.0.devname=/dev/video0 \
				ro.camera.0.facing=front \
				ro.camera.0.orientation=0

#Set ro.adb.secure to 0 for user build
ifeq ($(TARGET_BUILD_VARIANT), user)
ADDITIONAL_DEFAULT_PROPERTIES += \
                                ro.adb.secure=0
endif

# Define Platform Sensor Hub firmware name
SENSORHUB_FW_NAME := psh_byt_m_crb.bin
# Including OTC iago/gummiboot installer as new method of
# installation with EFI BIOS.
ifeq ($(TARGET_KERNEL_ARCH),)
TARGET_KERNEL_ARCH := i386
endif
# Allow creation of iago live USB/CD images
TARGET_USE_IAGO := true
TARGET_IAGO_PLUGINS := \
        bootable/iago/plugins/gummiboot \
        bootable/iago/plugins/syslinux \

TARGET_IAGO_INI := $(DEVICE_PATH)/iago.ini
TARGET_USE_MOKMANAGER := true

TARGET_EFI_APPS := \
        $(PRODUCT_OUT)/efi/gummiboot.efi \
        $(PRODUCT_OUT)/efi/shim.efi \

ifneq ($(TARGET_USE_MOKMANAGER),false)
TARGET_EFI_APPS += $(PRODUCT_OUT)/efi/MokManager.efi
endif

INSTALLED_EFI_BINARY_TARGET += $(TARGET_EFI_APPS)

ifeq ($(TARGET_BUILD_VARIANT),user)
TARGET_IAGO_INI += $(DEVICE_PATH)/iago-production.ini
endif

ifeq ($(TARGET_STAGE_USERFASTBOOT),true)
TARGET_IAGO_PLUGINS += bootable/iago/plugins/userfastboot
endif

TARGET_NO_BOOTLOADER := false

########################################################################
# PORTED FROM OTC FOR SIGNED BOOTIMAGE, THIS WILL BE OF INTEREST TO
# TEAM WORKING ON BOOTLOADER FOR BYT/CHT.
# Test key to sign boot image
#TARGET_BOOT_IMAGE_KEY := vendor/intel/support/testkeys/bios/DB.key

# Command run by MKBOOTIMG to sign target's boot image. It is expected to:
# () Take unsigned image from STDIN
# () Output signature's content ONLY to STDOUT
#TARGET_BOOT_IMAGE_SIGN_CMD := openssl dgst -sha256 -sign $(TARGET_BOOT_IMAGE_KEY)

#BOARD_MKBOOTIMG_ARGS := --signsize 256  --signexec "$(TARGET_BOOT_IMAGE_SIGN_CMD)"
########################################################################
