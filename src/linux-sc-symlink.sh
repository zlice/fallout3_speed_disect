#!/bin/sh

# Fallout3 speedcripple animation symlink script - zlice
#
# Usage:
# put the kf files below in your Fallout3/Data directory with
# this script
# mount UBS drive with user permissions or run this with sudo
# set 'usbdir' to the proper USB location
#

meshdir='meshes/characters/_male/locomotion/hurt'
usbdir='/PUT_YOUR_USB_MOUNT_POINT_HERE/speedcripple'
if ! echo $(pwd) | grep "Fallout3.Data" ; then
  echo "NOT IN Fallout3/Data DIRECTORY!"
  exit 1
fi
mkdir -p $meshdir
mkdir -p $usbdir
for i in mtfastbackward_hurt.kf mtfastleft_hurt.kf mtfastforward_hurt.kf mtfastright_hurt.kf ; do
  mv $i $mesdir/.
  ln -s $(pwd)/$meshdir/$i $usbdir/.
done
echo Complete
