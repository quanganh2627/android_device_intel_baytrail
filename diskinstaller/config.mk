# Diskinstaller can be used to flash a board from a USB stick
# when booting from EFI BIOS.

##### BRINGUP HACK - use prebuilt kernel 3.6 ######
TARGET_KERNEL_TARBALL := $(BYT_PATH)/diskinstaller/kernel.tgz
# Set to false to use prebuilt kernel in main OS
TARGET_KERNEL_SOURCE_IS_PRESENT := true
# Set to false to use generated kernel instead of prebuilt for the installer
TARGET_USE_INSTALLER_SPECIAL_PREBUILT_KERNEL := true

TARGET_USE_EFI := true

TARGET_NO_BOOTLOADER := false

TARGET_USE_SYSLINUX := true
TARGET_INSTALL_CUSTOM_SYSLINUX_CONFIG := true
SYSLINUX_BASE := $(HOST_OUT)/usr/lib/syslinux
TARGET_SYSLINUX_FILES := $(BYT_PATH)/diskinstaller/intellogo.png \
        $(SYSLINUX_BASE)/vesamenu.c32 \
        $(SYSLINUX_BASE)/android.c32

TARGET_SYSLINUX_FILES += $(PRODUCT_OUT)/kernel.efi \
                         $(PRODUCT_OUT)/ramdisk.img \
                         $(PRODUCT_OUT)/startup.nsh

TARGET_SYSLINUX_CONFIG_TEMPLATE := $(BYT_PATH)/diskinstaller/syslinux.template.cfg
TARGET_SYSLINUX_CONFIG := $(BYT_PATH)/diskinstaller/syslinux.cfg

TARGET_DISKINSTALLER_CONFIG := $(DEVICE_PATH)/installer.conf

# Causes bootable/diskinstaller/config.mk to be included which enables the
# installer_img build target.  For more information on the installer, see
# http://otc-android.intel.com/wiki/index.php/Installer
TARGET_USE_DISKINSTALLER := true

# Defines a partitioning scheme for the installer:
TARGET_DISK_LAYOUT_CONFIG := $(DEVICE_PATH)/disk_layout.conf

