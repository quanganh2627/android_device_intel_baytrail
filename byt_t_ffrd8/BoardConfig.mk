# Name of the reference design
# Should be changed with the original values when starting customization
REF_DEVICE_NAME ?= $(TARGET_DEVICE)
REF_PRODUCT_NAME ?= $(TARGET_PRODUCT)

TARGET_USE_DROIDBOOT := true

include $(PLATFORM_PATH)/BoardConfig.mk

# TEMPORARY : Capsule is not enabled for now
BOARD_HAS_CAPSULE := false

# Temporary IFWI does not support signing
TARGET_OS_SIGNING_METHOD := none

#Platform
BOARD_USES_48000_AUDIO_CAPTURE_SAMPLERATE_FOR_WIDI := true

# Connectivity
BOARD_HAVE_WIFI := true
INTEL_WIDI := true
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)
TARGET_HAS_VPP := true
TARGET_VPP_USE_GEN := true
COMMON_GLOBAL_CFLAGS += -DGFX_BUF_EXT
TARGET_HAS_MULTIPLE_DISPLAY := true

USE_INTEL_IPP := true

# WiDi
INTEL_WIDI_BAYTRAIL := true

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_TINY_ALSA_AUDIO := true
BOARD_USES_AUDIO_HAL_CONFIGURABLE := true
BOARD_USE_VIBRATOR_ALSA := false
BUILD_WITH_ALSA_UTILS := true
BOARD_USES_GENERIC_AUDIO := false
BOARD_HAVE_AUDIENCE := false

#GEN is one graphic and video engine
# Baytrail uses the GEN for the graphic and video
BOARD_GRAPHIC_IS_GEN := true

# Camera
# Set USE_CAMERA_STUB to 'true' for Fake Camera builds,
# 'false' for libcamera builds to use Camera Imaging(CI) supported by intel.
USE_CAMERA_STUB := false
USE_CAMERA_HAL2 := true

USE_INTEL_METABUFFER := true

USE_CSS_2_0 := true

# Enabled HW accelerated JPEG encoder using VA API
USE_INTEL_JPEG := false
# Enabled NXP Premium Audio Effect Libraries
USE_INTEL_LVSE := true
JPEGDEC_USES_GEN := true

ifeq ($(BOARD_KERNEL_CMDLINE),)
ifeq ($(TARGET_BUILD_VARIANT),eng)
BOARD_KERNEL_CMDLINE := console=ttyS0,115200 console=logk0 earlyprintk=nologger loglevel=8 drm.debug=0xe kmemleak=off ptrace.ptrace_can_access=1 emmc_ipanic.ipanic_part_number=3 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra) nmi_watchdog=panic softlockup_panic=1
else ifeq ($(TARGET_BUILD_VARIANT),userdebug)
BOARD_KERNEL_CMDLINE := console=ttyS0,115200 console=logk0 earlyprintk=nologger loglevel=4 kmemleak=off ptrace.ptrace_can_access=1 emmc_ipanic.ipanic_part_number=3 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra) nmi_watchdog=panic softlockup_panic=1
else
BOARD_KERNEL_CMDLINE := console=logk0 earlyprintk=nologger loglevel=0 kmemleak=off emmc_ipanic.ipanic_part_number=3 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra)
endif
endif

# Graphics
BOARD_GPU_DRIVERS := i965
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

# usb stick installer support
BOARD_KERNEL_DROIDBOOT_EXTRA_CMDLINE +=  droidboot.use_installer=1 droidboot.installer_usb=/dev/block/sda1 droidboot.installer_file=installer.cmd

# Temporary support for diskinstaller to be used with EFI BIOS.
# -> should go away as this is not needed with PSI firmware + OTG
include $(PLATFORM_PATH)/diskinstaller/config.mk
