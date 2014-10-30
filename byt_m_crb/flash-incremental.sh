#set -x

#Setting product out directory
export ANDROID_PRODUCT_OUT=.

FACTORY_IMG=byt_m_crb64-lrx19-factory.tgz
ZIP_IMG=byt_m_crb64-LRX19-img.zip

OPTIONS=$1
IP_ADDRESS=$2

#Error handler
error_handler()
{
  if [ "$1" != "0" ]; then
    ls
    echo "$2 file not present exit"
    exit
  fi
}

#check if IP address changed
check_IP_address()
{
  echo "====================================================================================="
  echo "Wait till fastboot "\"UI"\" or "\"device terminal"\" shows IP address"
  echo "Initial IP address is: $IP_ADDRESS"
  echo "Enter the new IP address if it is changed, else hit "\"Enter"\" to continue"
  read text
  if [ "$text" != "" ]; then
    IP_ADDRESS=$text
    echo "Using new IP address: $IP_ADDRESS"
  else
    echo "Retaining the initial IP address: $IP_ADDRESS"
  fi
  echo "====================================================================================="
}

#Information message
info_message()
{
  if [ "$1" == "msg1" ]; then
    echo "====================================================================================="
    echo "Reboot the device into fastboot mode"
    echo "*********************************************"
    echo "reboot -> F2 > Boot Manager -> EFI USB Device"
    echo "*********************OR**********************"
    echo "press "\"Volume Down Key"\""
    echo "*********************************************"
    echo "If finished, hit any key to continue"
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
    echo "====================================================================================="
  elif [ "$1" == "msg4" ]; then
    echo "====================================================================================="
    check_IP_address
    echo "====================================================================================="
  elif [ "$1" == "msg5" ]; then
    echo "====================================================================================="
    echo "doing oem $2"
    echo "If prompted, Please confirm the OEM $2 action using the UI"
    echo "Press UP button in target device and then hit Enter"
    echo "====================================================================================="
  else
    echo "Invalid selection"
  fi
}

#check the necessary files
ls $FACTORY_IMG
error_handler $? $FACTORY_IMG

#un-tar the factory image
tar -xvzf $FACTORY_IMG
unzip $ZIP_IMG

#OEM UNLOCK
info_message msg5 unlock
fastboot $OPTIONS $IP_ADDRESS oem unlock

#Flash the system related images
fastboot flashall $OPTIONS $IP_ADDRESS

info_message msg2
info_message msg1
info_message msg4

#OEM LOCK
info_message msg5 lock
fastboot $OPTIONS $IP_ADDRESS oem lock

info_message msg3
fastboot $OPTIONS $IP_ADDRESS reboot
