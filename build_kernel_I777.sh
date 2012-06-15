#!/bin/sh
#Copy the initramfs
echo "Remove old zImage"
rm zImage
echo "Create initramfs dir"
mkdir -p kernel/usr/initramfs
echo "Remove old initramfs dir"
rm -rf kernel/usr/initramfs/*
echo "Copy new initramfs dir"
cp -R ../miui_initramfs/* kernel/usr/initramfs
#echo "Remove .o files"
#rm -rf kernel/*.o
echo "chmod initramfs dir"
chmod -R g-w kernel/usr/initramfs/*
rm $(find kernel/usr/initramfs -name EMPTY_DIRECTORY -print)
rm -rf $(find kernel/usr/initramfs -name .git -print)
#Enable FIPS mode
export USE_SEC_FIPS_MODE=true
make miui_i777_defconfig
make -j`grep 'processor' /proc/cpuinfo | wc -l`
echo "Copying Modules"
cp -a $(find . -name *.ko -print |grep -v initramfs) kernel/usr/initramfs/lib/modules/
echo "Modules Copied"
sleep 5
touch kernel/usr/initramfs
echo "Rebuilding kernel with new initramfs"
make -j`grep 'processor' /proc/cpuinfo | wc -l`
cp arch/arm/boot/zImage zImage
# adb shell reboot download
# sleep 5
# heimdall flash --kernel arch/arm/boot/zImage
