#!/bin/sh
# reserved space of 256M to handle OSIP entries
# 2G fat partition
# usage: copy flashfile content to partition
# droidboot looks for installer.cmd file

if [ $# -eq 3 ]; then
    disk=$1
    droidboot_image=$2
    build_file=$3
else
    echo "Usage: $0 block_device droidboot.img flashfile.zip"
    exit
fi

if [ ! -b /dev/${disk} ]; then
    echo "$disk is not a valid block device... Aborting"
    exit
fi

disk_mounted=`mount | grep -c $disk`

if [ $disk_mounted -ge 1 ]; then
    echo "$disk seems to be mounted... Aborting"
    exit
fi


dd if=${droidboot_image} of=/dev/${disk} bs=1M

echo "unit: sectors" > /tmp/droidboot_installer_partition
echo "/dev/${disk}1 : start=   524322, size=  4194304, Id=83" >> /tmp/droidboot_installer_partition
echo "/dev/${disk}2 : start=        0, size=        0, Id= 0" >> /tmp/droidboot_installer_partition
echo "/dev/${disk}3 : start=        0, size=        0, Id= 0" >> /tmp/droidboot_installer_partition
echo "/dev/${disk}4 : start=        0, size=        0, Id= 0" >> /tmp/droidboot_installer_partition

sfdisk /dev/${disk} < /tmp/droidboot_installer_partition
mkfs.vfat /dev/${disk}1
mount /dev/${disk}1 /mnt
echo "Unzip $build_file to /mnt"
unzip $build_file -d /mnt
umount /mnt

