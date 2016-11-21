#!/bin/bash

gdisk /dev/vdb << EOF
n
1


8e00
p
w
Y
EOF

partprobe /dev/vdb

pvcreate /dev/vdb1
vgcreate vg1 /dev/vdb1

free_pe=`vgdisplay vg1 | grep Free | awk '{print$5}'`
lvcreate -l +${free_pe} -n export vg1
mkfs.ext4 /dev/vg1/export
tune2fs -m0 /dev/vg1/export
echo "/dev/mapper/vg1-export		/export		ext4	defaults 0 0" >> /etc/fstab
mount -a
