#!/bin/sh
# The base for the script stolen from http://superuser.com/questions/53978/automatically-mount-external-drives-to-media-label-on-boot-without-a-user-logge but heavily updated.
#
# USAGE: udev-auto-mount.sh mount|unmount DEVICE
#   DEVICE is the actual device node at /dev/DEVICE
# 
# This script takes a device name, looks up the partition label and
# type, creates /media/LABEL and mounts the partition.  Mount options
# are hard-coded below.
#
# When the device is removed, the partition is unmounted and the mount
# point is deleted.
#
# Add the following lines in for instance /etc/udev/rules.d/90-local.rules to makes udev run the script:
# ENV{DEVTYPE}=="partition", ACTION=="add", SUBSYSTEMS=="usb", RUN+="/usr/local/sbin/udev-auto-mount.sh mount %k &"
# ENV{DEVTYPE}=="partition", ACTION=="remove", SUBSYSTEMS=="usb", RUN+="/usr/local/sbin/udev-auto-mount.sh unmount %k &"
#

DEVICE=$2
DEVICENAME=$(udevadm info --query=property --name=/dev/$DEVICE | grep -i vendor= | awk -F\= '{ print $2}')

mount_device() {
  echo ${DEVICENAME} > /tmp/devicename_${DEVICE}

  MOUNTPT="/media/$DEVICENAME"
  # check input
  if [ -z "$DEVICE" ]; then
    exit 1
  fi

  # test that this device isn't already mounted
  device_is_mounted=`grep ${DEVICE} /etc/mtab`
  if [ -n "$device_is_mounted" ]; then
    echo "error: seems /dev/${DEVICE} is already mounted"
    exit 1
  fi

  # test mountpoint - it shouldn't exist
  if [ ! -e "${MOUNTPT}" ]; then

    # make the mountpoint
    mkdir "${MOUNTPT}"

    fstype=$(blkid /dev/$DEVICE  | awk -F\" '{ print $4 }')
    #fstype=vfat
    # mount the device
    # 
    # If expecting thumbdrives, you probably want 
    #      mount -t auto -o sync,noatime [...]
    # 
    # If drive is VFAT/NFTS, this mounts the filesystem such that all files
    # are owned by a std user instead of by root.  Change to your user's UID
    # (listed in /etc/passwd).  You may also want "gid=1000" and/or "umask=022", eg:
    #      mount -t auto -o uid=1000,gid=1000 [...]
    # 
    # 
    case "$fstype" in
      vfat)  mount -t vfat -o user,sync,noatime,uid=1000 /dev/${DEVICE} "${MOUNTPT}"
             ;;
      ntfs)  mount -t auto -o user,sync,noatime,uid=1000,locale=en_US.UTF-8 /dev/${DEVICE} "${MOUNTPT}"
             ;;
      # ext2/3/4 don't like uid option
      ext*)  mount -t auto -o user,sync,noatime /dev/${DEVICE} "${MOUNTPT}"
             ;;
    esac
  
    # all done here, return successful
    exit 0
  fi
}

unmount_device() {
  DEVICENAME=$(cat /tmp/devicename_${DEVICE})
  MOUNTPT="/media/$DEVICENAME"

  # check input
  if [ -z "$DEVICE" ]; then
    exit 1
    echo failed_device > /tmp/fail
  fi

  if [ -z "$MOUNTPT" ]; then
    exit 1
    echo failed_mountpt > /tmp/fail
  fi

  # test mountpoint - it should exist
  if [ -e "${MOUNTPT}" ]; then

    # very naive; just run and pray
    umount -l "${MOUNTPT}"
    rm -rf "${MOUNTPT}"
    rm -f /tmp/devicename_${DEVICE}
    exit 0

    echo "error: ${MOUNTPT} failed to unmount." > /tmp/failed
    exit 1
  else
    echo failed_unmount > /tmp/fail
  fi

  echo "error: ${MOUNTPT} does not exist"
  exit 1

}

case "$1" in
  mount)   mount_device
           ;;
  unmount) unmount_device
           ;;
esac

exit 0
