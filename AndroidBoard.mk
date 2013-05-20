# make file for Baytrail
#

include device/intel/common/AndroidBoard.mk

ifneq ($(TARGET_KERNEL_SOURCE_IS_PRESENT),false)
# Add socwatchdk driver
-include $(TOP)/linux/modules/debug_tools/socwatchdk/src/AndroidSOCWatchDK.mk

# Add VISA driver
-include $(TOP)/vendor/intel/tools/PRIVATE/debug_internal_tools/visadk/driver/src/AndroidVISA.mk
endif #TARGET_KERNEL_SOURCE_IS_PRESENT
