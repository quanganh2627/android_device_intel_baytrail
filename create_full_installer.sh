#!/bin/sh
# usage: copy flashfile content to directory
# droidboot looks for installer.cmd file

if [ $# -eq 3 ]; then
	path=$1
	blankphone_zip=$2
	fastboot_zip=$3
else
	echo "Usage: $0 output_dir blankphone.zip fastboot.zip"e
	exit
fi

unzip -o ${blankphone_zip} -d ${path} -x *.xml
unzip -o ${fastboot_zip} -d ${path} -x *.xml
sync


