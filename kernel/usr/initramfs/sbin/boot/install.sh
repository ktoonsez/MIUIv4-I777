if /sbin/ext/busybox [ ! -f /system/cfroot/release-107-LP7- ]; 
then
# Remount system RW
    /sbin/ext/busybox mount -o remount,rw /system
    /sbin/ext/busybox mount -t rootfs -o remount,rw rootfs

# Free some space
    toolbox rm /system/app/MobileODINFlasher.apk
    /sbin/ext/busybox cp /system/app/Maps.apk /Maps.tmp
    toolbox rm /system/app/Maps.apk

# ensure /system/xbin exists
    toolbox mkdir /system/xbin
    toolbox chmod 755 /system/xbin

# Superuser
    toolbox rm /system/app/Superuser.apk
    toolbox rm /data/app/Superuser.apk
    /sbin/ext/busybox dd if=/dev/block/mmcblk0p5 of=/system/app/Superuser.apk skip=7000000 seek=0 bs=1 count=563778
    toolbox chown 0.0 /system/app/Superuser.apk
    toolbox chmod 644 /system/app/Superuser.apk

# CWM Manager
    toolbox rm /system/app/CWMManager.apk
    toolbox rm /data/dalvik-cache/*CWMManager.apk*
    toolbox rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk

    /sbin/ext/busybox dd if=/dev/block/mmcblk0p5 of=/system/app/CWMManager.apk skip=6500000 seek=0 bs=1 count=331042
    toolbox chown 0.0 /system/app/CWMManager.apk
    toolbox chmod 644 /system/app/CWMManager.apk

# Restore Maps if possible
    /sbin/ext/busybox cp /Maps.tmp /system/app/Maps.apk
    toolbox chown 0.0 /system/app/Maps.apk
    toolbox chmod 644 /system/app/Maps.apk
    toolbox rm /Maps.tmp

# Once be enough
    toolbox mkdir /system/cfroot
    toolbox chmod 755 /system/cfroot
    toolbox rm /data/cfroot/*
    toolbox rmdir /data/cfroot
    toolbox rm /system/cfroot/*
    echo 1 > /system/cfroot/release-107-LP7- 

# Remount system RO
    /sbin/ext/busybox mount -t rootfs -o remount,ro rootfs
    /sbin/ext/busybox mount -o remount,ro /system
fi;
