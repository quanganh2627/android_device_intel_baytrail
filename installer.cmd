oem wipe ESP
oem wipe reserved
oem start_partitioning
oem partition /installer/partition.tbl
erase:factory
erase:system
erase:cache
erase:config
erase:logs
erase:data
oem stop_partitioning
flash:ESP#/installer/esp.img
flash:fastboot#/installer/droidboot.img
flash:boot#/installer/boot.img
flash:recovery#/installer/recovery.img
flash:system#/installer/system.img
flash:capsule#/installer/BYTC__X64_R_2014_24_4_01_SecEnabled.fv
continue
