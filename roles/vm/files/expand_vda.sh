#!/bin/bash

gdisk /dev/vda << EOF
n
4


8e00
p
w
Y
Y
EOF

gdisk /dev/vda << EOF
d
4
w
Y
EOF

gdisk /dev/vda << EOF
n
4


8e00
p
w
Y
Y
EOF

partprobe /dev/vda

pvcreate /dev/vda4
vgextend vg0 /dev/vda4

free_pe=`vgdisplay vg0 | grep Free | awk '{print$5}'`
lvextend -l +${free_pe} /dev/vg0/root
resize2fs /dev/vg0/root
