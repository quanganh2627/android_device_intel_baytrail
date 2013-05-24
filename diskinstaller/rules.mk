ifeq ($(TARGET_USE_DISKINSTALLER),true)

# 'make installer_img' to build the USB installer

# Trick the installer boot image into using Google mkbootimg with private var.
$(PRODUCT_OUT)/installer/installer_boot.img: MKBOOTIMG := out/host/linux-x86/bin/mkbootimg

# There is a dependency issue between fstab.baytrail which depends on bootimage and the installer.
# Fix it here but fstab should probably have a dependency to the ramdisk, not the bootimage.
installer_img: bootimage

#
# EFI for android
#
$(PRODUCT_OUT)/kernel.efi: $(PRODUCT_OUT)/kernel
	cp "$(PRODUCT_OUT)/kernel" "$(PRODUCT_OUT)/kernel.efi"

$(PRODUCT_OUT)/startup.nsh: $(PRODUCT_OUT)/kernel $(TARGET_DEVICE_DIR)/BoardConfig.mk
	echo "fs1:\kernel.efi $(BOARD_KERNEL_CMDLINE) initrd=ramdisk-installer.img.gz" > "$(PRODUCT_OUT)/startup.nsh"
	echo "fs0:\kernel.efi $(BOARD_KERNEL_CMDLINE) initrd=ramdisk.img" >> "$(PRODUCT_OUT)/startup.nsh"

endif #TARGET_USE_DISKINSTALLER
