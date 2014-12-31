# Include Kernel dependency file
include $(DEVICE_PATH)/definitions.mk

include $(PLATFORM_PATH)/AndroidBoard.mk

# parameter-framework
include $(DEVICE_CONF_PATH)/parameter-framework/AndroidBoard.mk

# FG config file
include $(DEVICE_CONF_PATH)/fg_config/AndroidBoard.mk

# Common config
include $(COMMON_PATH)/config/AndroidBoard.mk

ADDITIONAL_DEFAULT_PROPERTIES += persist.ril-daemon.disable=0


#- Start Bootloader--------------------------------------------------------------------------------#
ifneq ($(TARGET_USE_KERNELFLINGER),true)
# Rules to create bootloader zip file, a precursor to the bootloader
# image that is stored in the target-files-package. There's also
# metadata file which indicates how large to make the VFAT filesystem
# image

ifeq ($(TARGET_UEFI_ARCH),i386)
efi_default_name := bootia32.efi
else
efi_default_name := bootx64.efi
endif

# (pulled from build/core/Makefile as this gets defined much later)
# Pick a reasonable string to use to identify files.
ifneq "" "$(filter eng.%,$(BUILD_NUMBER))"
# BUILD_NUMBER has a timestamp in it, which means that
# it will change every time.  Pick a stable value.
FILE_NAME_TAG := eng.$(USER)
else
FILE_NAME_TAG := $(BUILD_NUMBER)
endif

loader_entries := $(wildcard device/intel/common/boot/loader/entries/*.conf)
loader_config := device/intel/common/boot/loader/loader.conf

intermediates := $(call intermediates-dir-for,PACKAGING,bootloader_zip)
bootloader_zip := $(intermediates)/bootloader.zip
$(bootloader_zip): intermediates := $(intermediates)
$(bootloader_zip): efi_root := $(intermediates)/root
$(bootloader_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(loader_entries) \
		$(loader_config) \
		$(BOARD_EFI_MODULES) \
		| $(ACP) \

	$(hide) rm -rf $(efi_root)
	$(hide) rm -f $@
	$(hide) mkdir -p $(efi_root)
	$(hide) mkdir -p $(efi_root)/loader/entries
	$(hide) $(ACP) $(loader_entries) $(efi_root)/loader/entries/
	$(hide) $(ACP) $(loader_config) $(efi_root)/loader/loader.conf
	$(hide) mkdir -p $(efi_root)/EFI/BOOT
	$(hide) $(ACP) $(BOARD_EFI_MODULES) $(efi_root)/
	$(hide) $(ACP) $(efi_root)/shim.efi $(efi_root)/EFI/BOOT/$(efi_default_name)
	$(hide) (cd $(efi_root) && zip -qry ../$(notdir $@) .)

bootloader_metadata := $(intermediates)/bootloader-size.txt
$(bootloader_metadata):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo $(BOARD_BOOTLOADER_PARTITION_SIZE) > $@

INSTALLED_RADIOIMAGE_TARGET += $(BOARD_GPT_INI) $(bootloader_zip) $(bootloader_metadata)

# Rule to create $(OUT)/bootloader image, binaries within are signed with
# testing keys

bootloader_bin := $(PRODUCT_OUT)/bootloader
$(bootloader_bin): \
		$(bootloader_zip) \
		device/intel/build/bootloader_from_zip \

	$(hide) device/intel/build/bootloader_from_zip \
		-i $(BOARD_BOOTLOADER_PARTITION_SIZE) \
		-z $(bootloader_zip) $@

droidcore: $(bootloader_bin)

.PHONY: bootloader
bootloader: $(bootloader_bin)
$(call dist-for-goals,droidcore,$(bootloader_bin):$(TARGET_PRODUCT)-bootloader-$(FILE_NAME_TAG))

usb_loader_entries := $(wildcard device/intel/common/boot/loader-usb/entries/*.conf)
usb_loader_config := device/intel/common/boot/loader-usb/loader.conf

intermediates := $(call intermediates-dir-for,PACKAGING,loader_usb_zip)
loader_usb_zip := $(intermediates)/loader_usb.zip

$(loader_usb_zip): intermediates := $(intermediates)
$(loader_usb_zip): efi_root := $(intermediates)/root
$(loader_usb_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(usb_loader_entries) \
		$(usb_loader_config) \
		$(BOARD_FASTBOOT_USB_EFI_MODULES) \
		| $(ACP) \

	$(hide) rm -rf $(efi_root)
	$(hide) rm -f $@
	$(hide) mkdir -p $(efi_root)
	$(hide) mkdir -p $(efi_root)/loader/entries
	$(hide) $(ACP) $(usb_loader_entries) $(efi_root)/loader/entries/
	$(hide) $(ACP) $(usb_loader_config) $(efi_root)/loader/loader.conf
	$(hide) $(ACP) $(BOARD_FASTBOOT_USB_EFI_MODULES) $(efi_root)
	$(hide) mkdir -p $(efi_root)/EFI/BOOT
	$(hide) $(ACP) $(efi_root)/shim.efi $(efi_root)/EFI/BOOT/$(efi_default_name)
	$(hide) (cd $(efi_root) && zip -qry ../$(notdir $@) .)

INSTALLED_RADIOIMAGE_TARGET += $(loader_usb_zip)

fastboot_usb_bin := $(PRODUCT_OUT)/fastboot-usb.img
$(fastboot_usb_bin): \
		$(loader_usb_zip) \
		$(PRODUCT_OUT)/fastboot.img \
		device/intel/build/fastboot_usb_from_zip \

	$(hide) device/intel/build/fastboot_usb_from_zip \
		--zipfile $(loader_usb_zip) \
		--fastboot $(PRODUCT_OUT)/fastboot.img $@

# Build when 'make' is run with no args
droidcore: $(fastboot_usb_bin)

.PHONY: userfastboot-usb
userfastboot-usb: $(fastboot_usb_bin)

$(call dist-for-goals,droidcore,$(fastboot_usb_bin):$(TARGET_PRODUCT)-fastboot-usb-$(FILE_NAME_TAG).img)
else #TARGET_USE_KERNELFLINGER
# Rules to create bootloader zip file, a precursor to the bootloader
# image that is stored in the target-files-package. There's also
# metadata file which indicates how large to make the VFAT filesystem
# image

ifeq ($(TARGET_UEFI_ARCH),i386)
efi_default_name := bootia32.efi
else
efi_default_name := bootx64.efi
endif

# (pulled from build/core/Makefile as this gets defined much later)
# Pick a reasonable string to use to identify files.
ifneq "" "$(filter eng.%,$(BUILD_NUMBER))"
# BUILD_NUMBER has a timestamp in it, which means that
# it will change every time.  Pick a stable value.
FILE_NAME_TAG := eng.$(USER)
else
FILE_NAME_TAG := $(BUILD_NUMBER)
endif

# We stash a copy of BIOSUPDATE.fv so the FW sees it, applies the
# update, and deletes the file. Follows Google's desire to update
# all bootloader pieces with a single "fastboot flash bootloader"
# command. We place the fastboot.img in the ESP for the same reason.
# Since it gets deleted we can't do incremental updates of it, we
# keep a copy in the system partition for this purpose.
intermediates := $(call intermediates-dir-for,PACKAGING,bootloader_zip)
bootloader_zip := $(intermediates)/bootloader.zip
$(bootloader_zip): intermediates := $(intermediates)
$(bootloader_zip): efi_root := $(intermediates)/root
$(bootloader_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(BOARD_FIRST_STAGE_LOADER) \
		$(BOARD_EXTRA_EFI_MODULES) \
		$(BOARD_SFU_UPDATE) \
		| $(ACP) \

	$(hide) rm -rf $(efi_root)
	$(hide) rm -f $@
	$(hide) mkdir -p $(efi_root)
	$(hide) mkdir -p $(efi_root)/EFI/BOOT
ifneq ($(BOARD_EXTRA_EFI_MODULES),)
	$(hide) $(ACP) $(BOARD_EXTRA_EFI_MODULES) $(efi_root)/
endif
ifneq ($(BOARD_SFU_UPDATE),)
	$(hide) $(ACP) $(BOARD_SFU_UPDATE) $(efi_root)/BIOSUPDATE.fv
endif
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/loader.efi
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/EFI/BOOT/$(efi_default_name)
	$(hide) $(ACP) $(LOADER_PREBUILT)/efitools/linux-x86_64/LockDown.efi $(efi_root)/LockDown.efi
	$(hide) $(ACP) $(LOADER_PREBUILT)/efitools/linux-x86_64/production-test/LockDownPT.efi $(efi_root)/LockDownPT.efi
	$(hide) (cd $(efi_root) && zip -qry ../$(notdir $@) .)

bootloader_metadata := $(intermediates)/bootloader-size.txt
$(bootloader_metadata):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo $(BOARD_BOOTLOADER_PARTITION_SIZE) > $@

INSTALLED_RADIOIMAGE_TARGET += $(BOARD_GPT_INI) $(bootloader_zip) $(bootloader_metadata)

# Rule to create $(OUT)/bootloader image, binaries within are signed with
# testing keys

bootloader_bin := $(PRODUCT_OUT)/bootloader
$(bootloader_bin): \
		$(bootloader_zip) \
		$(PRODUCT_OUT)/fastboot.img \
		device/intel/build/bootloader_from_zip \

	$(hide) device/intel/build/bootloader_from_zip \
		--size $(BOARD_BOOTLOADER_PARTITION_SIZE) \
		--fastboot $(PRODUCT_OUT)/fastboot.img \
		--zipfile $(bootloader_zip) \
		$@

droidcore: $(bootloader_bin)

.PHONY: bootloader
bootloader: $(bootloader_bin)
$(call dist-for-goals,droidcore,$(bootloader_bin):$(TARGET_PRODUCT)-bootloader-$(FILE_NAME_TAG))

fastboot_usb_bin := $(PRODUCT_OUT)/fastboot-usb.img
$(fastboot_usb_bin): \
		$(bootloader_zip) \
		$(PRODUCT_OUT)/fastboot.img \
		device/intel/build/bootloader_from_zip \

	$(hide) device/intel/build/bootloader_from_zip \
		--fastboot $(PRODUCT_OUT)/fastboot.img \
		--zipfile $(bootloader_zip) \
		--extra-size 10485760 \
		--bootable \
		$@

# Build when 'make' is run with no args
droidcore: $(fastboot_usb_bin)

.PHONY: userfastboot-usb
userfastboot-usb: $(fastboot_usb_bin)

$(call dist-for-goals,droidcore,$(fastboot_usb_bin):$(TARGET_PRODUCT)-fastboot-usb-$(FILE_NAME_TAG).img)

ifneq ($(BOARD_SFU_UPDATE),)
$(call dist-for-goals,droidcore,$(BOARD_SFU_UPDATE):$(TARGET_PRODUCT)-sfu-$(FILE_NAME_TAG).fv)
endif

$(call dist-for-goals,droidcore,$(LOADER_PREBUILT)/efitools/$(LOADER_TYPE)/LockDown.efi:LockDown.efi)
endif #TARGET_USE_KERNELFLINGER
#- End Bootloader----------------------------------------------------------------------------------#
