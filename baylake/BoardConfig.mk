# Name of the reference design
# Should be changed with the original values when starting customization
REF_DEVICE_NAME ?= $(TARGET_DEVICE)
REF_PRODUCT_NAME ?= $(TARGET_PRODUCT)

DEVICE_PATH := vendor/intel/baytrail/baylake

# For targets that use EFI
TARGET_USE_EFI := true

TARGET_USE_DROIDBOOT := true

#Intel recovery images and boot images are different from android images.
# **** Disable these as we need to have the standard android images that use
# **** mkbootimg standard AOSP version.
TARGET_MAKE_NO_DEFAULT_BOOTIMAGE := true
TARGET_MAKE_INTEL_BOOTIMAGE := true
##### BRINGUP HACK - use prebuilt kernel 3.6 ######
TARGET_KERNEL_SOURCE_IS_PRESENT := true
TARGET_USE_INSTALLER_SPECIAL_PREBUILT_KERNEL := true
TARGET_KERNEL_TARBALL := $(DEVICE_PATH)/kernel.tgz

include vendor/intel/baytrail/BoardConfig.mk

# Temporary IFWI does not support signing
TARGET_OS_SIGNING_METHOD := none
TARGET_OUT_IFWIS := $(TARGET_OUT_INTERMEDIATES)/IFWIS/baylake_ifwi/

TARGET_PRELINK_MODULE := false
TARGET_PROVIDES_INIT_RC := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_RIL_DISABLE_STATUS_POLLING := true

#Platform
BOARD_USES_48000_AUDIO_CAPTURE_SAMPLERATE_FOR_WIDI := true

# Connectivity
BOARD_HAVE_WIFI := true
INTEL_WIDI := false
BOARD_HAVE_BLUETOOTH := false
BOARD_HAVE_GPS := false
TARGET_HAS_VPP := true
TARGET_VPP_USE_GEN := true
COMMON_GLOBAL_CFLAGS += -DGFX_BUF_EXT

USE_INTEL_IPP := true

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_AUDIO_HAL_CONFIGURABLE := true
BOARD_USE_VIBRATOR_ALSA := false
BUILD_WITH_ALSA_UTILS := true
BOARD_USES_GENERIC_AUDIO := false
BOARD_HAVE_AUDIENCE := false

# Board configuration for Intel PC STD platform

TARGET_NO_BOOTLOADER := false

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

ifeq ($(BOARD_KERNEL_CMDLINE),)
BOARD_KERNEL_CMDLINE := console=ttyS0,115200 console=logk0 earlyprintk=nologger loglevel=4 kmemleak=off emmc_ipanic.ipanic_part_number=3 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) $(cmdline_extra)
endif

# Graphics
BOARD_GPU_DRIVERS := i965
USE_OPENGL_RENDERER := true
BOARD_KERNEL_CMDLINE += vga=current i915.modeset=1 drm.vblankoffdelay=1 \
                        acpi_backlight=vendor

TARGET_USE_SYSLINUX := true
TARGET_INSTALL_CUSTOM_SYSLINUX_CONFIG := true
SYSLINUX_BASE := $(HOST_OUT)/usr/lib/syslinux
TARGET_SYSLINUX_FILES := $(DEVICE_PATH)/intellogo.png \
        $(SYSLINUX_BASE)/vesamenu.c32 \
        $(SYSLINUX_BASE)/android.c32

TARGET_SYSLINUX_FILES += $(PRODUCT_OUT)/kernel.efi \
                         $(PRODUCT_OUT)/ramdisk.img \
                         $(PRODUCT_OUT)/startup.nsh

TARGET_SYSLINUX_CONFIG_TEMPLATE := $(DEVICE_PATH)/syslinux.template.cfg

TARGET_SYSLINUX_CONFIG := $(DEVICE_PATH)/syslinux.cfg
TARGET_DISKINSTALLER_CONFIG := $(DEVICE_PATH)/installer.conf

# Causes bootable/diskinstaller/config.mk to be included which enables the
# installer_img build target.  For more information on the installer, see
# http://otc-android.intel.com/wiki/index.php/Installer
TARGET_USE_DISKINSTALLER := true

# Defines a partitioning scheme for the installer:
TARGET_DISK_LAYOUT_CONFIG := $(DEVICE_PATH)/disk_layout.conf

BOARD_USES_LIBPSS := false

INTEL_VA:=true
USE_INTEL_VA:=true
BOARD_USES_WRS_OMXIL_CORE:=true
BOARD_USES_MRST_OMX:=true
USE_INTEL_ASF_EXTRACTOR:=true

BOARD_USE_LIBVA_INTEL_DRIVER := true
BOARD_USE_LIBVA := true
BOARD_USE_LIBMIX := true

# Settings for the Media SDK library and plug-ins:
# - USE_MEDIASDK: use Media SDK support or not
# - MFX_IPP: sets IPP library optimization to use
USE_MEDIASDK := true
# Enable CIP Codecs
USE_INTEL_MDP := true
MFX_IPP := p8

# Defines Intel library for GPU accelerated Renderscript:
OVERRIDE_RS_DRIVER := libRSDriver_intel7.so
