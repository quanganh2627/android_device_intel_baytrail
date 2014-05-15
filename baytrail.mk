TARGET_BOARD_PLATFORM := baytrail
TARGET_BOARD_SOC := valleyview2
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

# Include common environnement
include device/intel/common/common.mk

# USB port turn around and initialization
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/init.byt.usb.rc:root/init.platform.usb.rc \
    $(PLATFORM_CONF_PATH)/init.byt.gengfx.rc:root/init.platform.gengfx.rc \
    $(PLATFORM_CONF_PATH)/props.baytrail.rc:root/props.platform.rc \
    $(PLATFORM_CONF_PATH)/atmel_mxt_ts.idc:system/usr/idc/atmel_mxt_ts.idc \
    $(PLATFORM_CONF_PATH)/goodix_ts.idc:system/usr/idc/goodix_ts.idc \
    $(PLATFORM_CONF_PATH)/ft5x0x_ts.idc:system/usr/idc/ft5x0x_ts.idc \
    $(PLATFORM_CONF_PATH)/synaptics_dsx.idc:system/usr/idc/synaptics_dsx.idc \
    $(PLATFORM_CONF_PATH)/GSL_TP.idc:system/usr/idc/GSL_TP.idc

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/init.nodebug.rc:root/init.debug.rc
else
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/init.debug.rc:root/init.debug.rc
endif


# Kernel Watchdog
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdogd.rc:root/init.watchdog.rc
ifeq ($(TARGET_BIOS_TYPE),"uefi")
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdog_uefi.sh:root/init.watchdog.sh
PRODUCT_PACKAGES += \
    uefivar
else
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/watchdog/init.watchdog.sh:root/init.watchdog.sh
PRODUCT_PACKAGES += \
    ia32fw \
    ia32fw_dfx
endif

# Firmware versioning
ifeq ($(TARGET_BIOS_TYPE),"uefi")
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/firmware/smbios_firmware_props.rc:root/init.firmware.rc
PRODUCT_PACKAGES += \
    intel_fw_props
else
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/firmware/pidv_firmware_props.rc:root/init.firmware.rc
endif

#keylayout file
PRODUCT_COPY_FILES += \
    $(PLATFORM_CONF_PATH)/intel_short_long_press.kl:system/usr/keylayout/baytrailaudio_Intel_MID_Audio_Jack.kl

# parameter-framework
PRODUCT_PACKAGES += \
    libparameter \
    parameter-connector-test \
    libxmlserializer \
    liblpe-subsystem \
    libtinyamixer-subsystem \
    libtinyalsactl-subsystem \
    libfs-subsystem \
    libproperty-subsystem \
    parameter

# Add charger app
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# remote-process for parameter-framework tuning interface
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    libremote-processor \
    remote-process
endif

# Add FPT and TXEManuf
PRODUCT_PACKAGES_ENG += FPT TXEManuf

# Add HdmiSettings app
PRODUCT_PACKAGES += \
    HdmiSettings

# Ota and Ota Downloader
PRODUCT_PACKAGES += \
    Ota \
    OtaDownloader

# Crash Report / crashinfo
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    crash_package
endif

# light
PRODUCT_PACKAGES += \
    lights.$(PRODUCT_DEVICE)

# sensorhub
PRODUCT_PACKAGES += \
    sensorhubd      \
    psh_bk.bin      \
    fwupdatetool    \
    fwupdate_script.sh

# rfid/pss service
PRODUCT_PACKAGES += \
    rfid_monzaxd

# Identity Protection Technology (IPT)
PRODUCT_PACKAGES += \
    libiha \
    libsepipt \
    EPIDClientConfig.txt \
    epid_paramcert.dat \
    Group_1244_Public_Key.cer \
    Group_2167_Public_Key.cer \
    Group_2168_Public_Key.cer \
    Group_2169_Public_Key.cer \
    Group_2170_Public_Key.cer \
    Group_2171_Public_Key.cer \
    Group_2172_Public_Key.cer \
    Group_2173_Public_Key.cer \
    Group_2174_Public_Key.cer \
    Group_2175_Public_Key.cer \
    Group_2176_Public_Key.cer \
    Group_2177_Public_Key.cer \
    Group_2178_Public_Key.cer \
    Group_2179_Public_Key.cer \
    Group_2180_Public_Key.cer \
    Group_2181_Public_Key.cer \
    Group_2182_Public_Key.cer \
    Group_2183_Public_Key.cer \
    Group_2184_Public_Key.cer \
    Group_2185_Public_Key.cer \
    Group_2186_Public_Key.cer \
    Group_2187_Public_Key.cer \
    Group_2188_Public_Key.cer \
    Group_2189_Public_Key.cer \
    Group_2190_Public_Key.cer \
    Group_2191_Public_Key.cer \
    Group_2192_Public_Key.cer \
    Group_2193_Public_Key.cer \
    Group_2194_Public_Key.cer \
    Group_2195_Public_Key.cer \
    Group_2196_Public_Key.cer \
    Group_2197_Public_Key.cer \
    Group_2198_Public_Key.cer \
    Group_2199_Public_Key.cer \
    Group_2200_Public_Key.cer \
    Group_2201_Public_Key.cer \
    Group_2202_Public_Key.cer \
    Group_2203_Public_Key.cer \
    Group_2204_Public_Key.cer \
    Group_2205_Public_Key.cer \
    Group_2206_Public_Key.cer \
    Group_2207_Public_Key.cer \
    Group_2208_Public_Key.cer \
    Group_2209_Public_Key.cer \
    Group_2210_Public_Key.cer \
    Group_2211_Public_Key.cer \
    Group_2212_Public_Key.cer \
    Group_2213_Public_Key.cer \
    Group_2214_Public_Key.cer \
    Group_2215_Public_Key.cer \
    Group_2216_Public_Key.cer \
    Group_2217_Public_Key.cer \
    Group_2218_Public_Key.cer \
    Group_2219_Public_Key.cer \
    Group_2220_Public_Key.cer \
    Group_2221_Public_Key.cer \
    Group_2222_Public_Key.cer \
    Group_2223_Public_Key.cer \
    Group_2224_Public_Key.cer \
    Group_2225_Public_Key.cer \
    Group_2226_Public_Key.cer \
    Group_2227_Public_Key.cer \
    Group_2228_Public_Key.cer \
    Group_2229_Public_Key.cer \
    Group_2230_Public_Key.cer \
    Group_2231_Public_Key.cer \
    Group_2232_Public_Key.cer \
    Group_2233_Public_Key.cer \
    Group_2234_Public_Key.cer \
    Group_2235_Public_Key.cer \
    Group_2236_Public_Key.cer \
    Group_2237_Public_Key.cer \
    Group_2238_Public_Key.cer \
    Group_2239_Public_Key.cer \
    Group_2240_Public_Key.cer \
    Group_2241_Public_Key.cer \
    Group_2242_Public_Key.cer \
    Group_2243_Public_Key.cer \
    Group_2244_Public_Key.cer \
    Group_2245_Public_Key.cer \
    Group_2246_Public_Key.cer \
    Group_2247_Public_Key.cer \
    Group_2248_Public_Key.cer \
    Group_2249_Public_Key.cer \
    Group_2250_Public_Key.cer \
    Group_2251_Public_Key.cer \
    Group_2252_Public_Key.cer \
    Group_2253_Public_Key.cer \
    Group_2254_Public_Key.cer \
    Group_2255_Public_Key.cer \
    Group_2256_Public_Key.cer \
    Group_2257_Public_Key.cer \
    Group_2258_Public_Key.cer \
    Group_2259_Public_Key.cer \
    Group_2260_Public_Key.cer \
    Group_2261_Public_Key.cer \
    Group_2262_Public_Key.cer \
    Group_2263_Public_Key.cer \
    Group_2264_Public_Key.cer \
    Group_2265_Public_Key.cer \
    Group_2266_Public_Key.cer \
    PAVP_Group_VLV2EPIDPREPROD_Public_Keys.bin \
    PAVP_Group_VLV2EPIDPROD_Public_Keys.bin

# Security service
PRODUCT_PACKAGES += \
    com.intel.security.service.sepmanager \
    com.intel.security.service.sepmanager.xml \
    com.intel.security.lib.sepdrmjni \
    com.intel.security.lib.sepdrmjni.xml \
    libsepdrmjni \
    SepService


# Keymaster HAL
PRODUCT_PACKAGES += \
    keystore.$(TARGET_BOARD_PLATFORM)


# Adding for Netflix app to do dynamic resolution switching
ADDITIONAL_BUILD_PROPERTIES += ro.streaming.video.drs=true
# Disable the graceful shutdown in case of "longlong" press on power
ADDITIONAL_BUILD_PROPERTIES += ro.disablelonglongpress=true
