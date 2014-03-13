#!/system/bin/sh

if [ "$#" != 1 ]; then
    echo "usage: $0 <iface>"
    exit 1
fi

active_iface="$1"
utility_iface=`getprop persist.sys.utility_iface`

if [ "$active_iface" != "$utility_iface" ]; then
    exit 0
fi

addr=`getprop net.utilitynet.ip`
netmask=`getprop net.utilitynet.netmask`

if [ -z "$addr" -o -f /sdcard/use_dhcp ]; then
    /system/bin/dhcpcd -bd $utility_iface
else
    ifconfig $utility_iface $addr netmask $netmask up
fi

exit 0
