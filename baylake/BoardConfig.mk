# Name of the reference design
# Should be changed with the original values when starting customization
REF_DEVICE_NAME := $(TARGET_DEVICE)
REF_PRODUCT_NAME := $(TARGET_PRODUCT)

#TARGET_USE_DROIDBOOT = true

include vendor/intel/baytrail/BoardConfig.mk

TARGET_PRELINK_MODULE := false
TARGET_PROVIDES_INIT_RC := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_RIL_DISABLE_STATUS_POLLING := true

#Platform
BOARD_USES_48000_AUDIO_CAPTURE_SAMPLERATE_FOR_WIDI := true

# WIFI
BOARD_HAVE_WIFI := false
INTEL_WIDI := false
BOARD_HAVE_BLUETOOTH := false

INTEL_HWC := true
INTEL_VA := true
INTEL_AMC := true
BOARD_HAVE_ATPROXY := false

#FM
BUILD_FM_RADIO := false
FM_CHR_DEV_ST := false
BUILD_FM_RADIO_RX := false
BUILD_FM_RADIO_TX := false
FM_RADIO_RX_ANALOG := false

TARGET_PHONE_HAS_OEM_LIBRARY := true
BOARD_HAVE_MODEM := false
BOARD_MODEM_DICO := "PR2:6360"
BOARD_MODEM_LIST := 6360
BOARD_HAVE_IFX6160 := true
BOARD_HAVE_IFX6360 := true
BOARD_USES_VIDEO := false
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_AUDIO_HAL_IA_CONTROLLED_SSP := true
BOARD_USE_VIBRATOR_ALSA := false
BUILD_WITH_ALSA_UTILS := true
BOARD_USES_GENERIC_AUDIO := false
BOARD_HAVE_AUDIENCE := true
BOARD_USES_WRS_OMXIL_CORE := true
ifeq ($(strip $(BOARD_USES_WRS_OMXIL_CORE)),true)
 BOARD_USES_MRST_OMX := true
endif
FLASHFILE_NO_OTA := false

# Set M2_VT_FEATURE_ENABLED to 'true' to enable M2 VT (Video Telephony) feature
M2_VT_FEATURE_ENABLED := false

# Set M2_CALL_FAILED_CAUSE_FEATURE_ENABLED to 'true' to  enable M2 call failed cause featur
M2_CALL_FAILED_CAUSE_FEATURE_ENABLED := false

# Set M2_PIN_RETRIES_FEATURE_ENABLED to 'true' to enable M2 pin retries feature
M2_PIN_RETRIES_FEATURE_ENABLED := false

# Set M2_GET_SIM_SMS_STORAGE_ENABLED to 'true' to enable M2 Get SIM SMS Storage feature
M2_GET_SIM_SMS_STORAGE_ENABLED := false

# BOARD_USES_CAMERA_TEXTURE_STREAMING := true

# Enabled to replace PV C reference audio decoders with Intel IPP-optimized  decoders
USE_INTEL_IPP := true
# enabled to use Intel video accelerator
USE_INTEL_VA := true
# enabled to use Intel custom AVC Stagefright HW decoder to support Flash Player Integration
USE_INTEL_AVC := true
# enabled to use Intel ASF Extractor
USE_INTEL_ASF_EXTRACTOR := true
ENABLE_IMG_GRAPHICS := true
# enabled to use ALAC
USE_FEATURE_ALAC := true
# enabled to use Intel audio SRC (sample rate conversion)
USE_INTEL_SRC := true
# enable to use Intel music offload
INTEL_MUSIC_OFFLOAD_FEATURE := true
# Enabled HW accelerated JPEG encoder using VA API
USE_INTEL_JPEG := true

# default sampling rate supported
DEFAULT_SAMPLING_RATE := 48000

# enabled to carry out all drawing operations performed on a View's canvas with GPU for 2D rendering pipeline.
USE_OPENGL_RENDERER := true

# enabled to use Intel NV12 version for video editor
USE_VIDEOEDITOR_INTEL_NV12_VERSION := true

# Camera
# Set USE_CAMERA_STUB to 'true' for Fake Camera builds,
# 'false' for libcamera builds to use Camera Imaging(CI) supported by intel.
USE_CAMERA_STUB := false
USE_INTEL_HDMI  := false
BOARD_USES_FORCE_SET_DISPLAY_BGRA_8888 := true

#GFX
BOARD_GFX_REV := SGX544

#HDCP
ENABLE_HDCP := true

TARGET_KERNEL_TARBALL := $(TOP)/device/intel/prebuilt/kernel.$(REF_DEVICE_NAME).tar.gz

ADDITIONAL_DEFAULT_PROPERTIES += ro.sf.lcd_density=320 \
                                 panel.physicalWidthmm=54 \
                                 panel.physicalHeightmm=95 \
                                 ro.opengles.version = 131072 \
                                 gsm.net.interface=rmnet0

# At-Proxy mode: 0 = disable, 1 = enable (normal mode), 2 = enable (tunneling mode)
ADDITIONAL_DEFAULT_PROPERTIES += persist.system.at-proxy.mode=0


ifeq ($(BOARD_KERNEL_CMDLINE),)
ifeq ($(TARGET_BUILD_VARIANT),eng)
BUILD_INIT_EXEC := true
BOARD_KERNEL_CMDLINE := init=/init pci=noearly console=ttyMFD2 console=ttyS0 console=logk0 earlyprintk=nologger loglevel=8 hsu_dma=7 kmemleak=off ptrace.ptrace_can_access=1 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) emmc_ipanic.ipanic_part_number=1 $(cmdline_extra) ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on hsu_rx_wa
else
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
BOARD_KERNEL_CMDLINE := init=/init pci=noearly console=ttyS0 console=logk0 earlyprintk=nologger loglevel=4 hsu_dma=7 kmemleak=off ptrace.ptrace_can_access=1 androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) emmc_ipanic.ipanic_part_number=1 $(cmdline_extra) ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on hsu_rx_wa
else
BOARD_KERNEL_CMDLINE := init=/init pci=noearly console=ttyS0 console=logk0 earlyprintk=nologger loglevel=4 hsu_dma=7 kmemleak=off androidboot.bootmedia=$(BOARD_BOOTMEDIA) androidboot.hardware=$(TARGET_DEVICE) emmc_ipanic.ipanic_part_number=1 $(cmdline_extra) ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on hsu_rx_wa
endif
endif
endif


# Enable CIP Codecs
USE_INTEL_MDP := true

