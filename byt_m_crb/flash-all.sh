#set -x
GPT_INT=byt_m_crb-gpt.ini
FACTORY_IMG=byt_m_crb_64-lmp-factory.tgz
BOOT_LOADER=byt_m_crb_64-LMP-bootloader
ZIP_IMG=byt_m_crb_64-LMP-img.zip

#Error handler
error_handler()
{
  if [ "$1" != "0" ]; then
    ls
    echo "$2 file not present exit"
    exit
  fi
}

#Information message
info_message()
{
  if [ "$1" == "msg1" ]; then
    echo "====================================================================================="
    echo "Reboot the device into fastboot mode"
    echo "reboot -> F2 > Boot Manager -> EFI USB Device"
    echo "When fastboot UI shows IP address, hit any key to continue"
    read text
    echo "====================================================================================="
  elif [ "$1" == "msg2" ]; then
    echo "====================================================================================="
    echo "Rebooting the device"
    echo "====================================================================================="
  elif [ "$1" == "msg3" ]; then
    echo "====================================================================================="
    echo "Congratulations you have finished flashing the device"
    echo "Your device is locked and ready to be used"
    echo "Remove the fastboot USB hooked into device and hit any key to continue"
    echo "====================================================================================="
  elif [ "$1" == "msg4" ]; then
    echo "====================================================================================="
    echo "When fastboot UI shows IP address, hit any key to continue"
    read text
    echo "====================================================================================="
  elif [ "$1" == "msg5" ]; then
    echo "====================================================================================="
    echo "doing oem $2"
    echo "If prompted, Please confirm the OEM $2 action using the UI"
    echo "Press UP or Down button in target device and then hit Enter"
    echo "====================================================================================="
  else
    echo "Invalid selection"
  fi
}

#check the necessary files
ls $FACTORY_IMG
error_handler $? $FACTORY_IMG
ls $GPT_INT
error_handler $? $GPT_INT

#un-tar the factory image
tar -xvzf $FACTORY_IMG

#OEM UNLOCK
info_message msg5 unlock
fastboot "$@" oem unlock

#Flash the GPT
fastboot "$@" flash gpt $GPT_INT

#Flsh the bootloader
fastboot "$@" flash bootloader $BOOT_LOADER

fastboot "$@" reboot-bootloader
info_message msg2
info_message msg4

#Flash the system related images
fastboot "$@" -w update $ZIP_IMG

info_message msg2
info_message msg1

#OEM LOCK
info_message msg5 lock
fastboot "$@" oem lock

info_message msg3
fastboot "$@" reboot
