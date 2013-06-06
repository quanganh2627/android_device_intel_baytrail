### TEMPORARY: override flashfiles defined in common until baytrail supports them
### TEMPORARY: to be removed once BZ 105857 implemented

flashfiles: $(PRODUCT_OUT)/partition.tbl
	@$(eval FLASHFILE_PATH := $(PUBLISH_PATH)/$(TARGET_PUBLISH_PATH)/flash_files/build-$(PUBLISH_TARGET_BUILD_VARIANT))
	@$(eval FLASHFILE_NAME := $(GENERIC_TARGET_NAME)-$(PUBLISH_TARGET_BUILD_VARIANT)-fastboot-$(FILE_NAME_TAG).zip)
	@echo "Generating $(FLASHFILE_PATH)/$(FLASHFILE_NAME)"
	@mkdir -p $(FLASHFILE_PATH)
	@rm -rf $(FLASHFILE_PATH)/*
	@cp $(PRODUCT_OUT)/kernel $(FLASHFILE_PATH)/mos_kernel.efi
	@cp $(PRODUCT_OUT)/ramdisk.img $(FLASHFILE_PATH)/mos_ramdisk.img
	@cp $(PRODUCT_OUT)/boot.bin $(FLASHFILE_PATH)/
	@cp $(PRODUCT_OUT)/droidboot.img $(FLASHFILE_PATH)/
	@cp $(PRODUCT_OUT)/recovery.img $(FLASHFILE_PATH)/
	@cp $(INSTALLED_SYSTEMIMG_GZ_TARGET) $(FLASHFILE_PATH)/
	@cp $(TARGET_DEVICE_DIR)/flash.xml $(FLASHFILE_PATH)/
	@cp $(TARGET_DEVICE_DIR)/flash_capsule.xml $(FLASHFILE_PATH)/
	@cp $(OUT)/partition.tbl $(FLASHFILE_PATH)/
	@cp $(IFWI_PREBUILT_PATHS)/dediprog.bin $(FLASHFILE_PATH)/
	@cp $(IFWI_PREBUILT_PATHS)/capsule.bin $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin
	@cp $(PRODUCT_OUT)/byt_psi_encapsulated_ifwi.bin $(FLASHFILE_PATH)/
	@zip -j $(FLASHFILE_PATH)/$(FLASHFILE_NAME) $(FLASHFILE_PATH)/*
	@find $(FLASHFILE_PATH) -name '*.zip' -prune -o -type f -exec rm {} \;

blank_flashfiles:
	@echo "No $@"
