#!/bin/bash
echo 'Downloading the ISO image...'
wget https://dl.armbian.com/orangepi5-plus/Noble_current_server-kisak -O Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img.xz

echo 'Checking the SHA256 checksum...'
shasum -a 256 -c img.xz.sha

unxz Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img.xz

sudo mkdir image
OFFSET=$(fdisk -l Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img | grep '^Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img' | awk '{print $2 * 512}')
sudo mount -o loop,offset=$OFFSET Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img image

sudo cp image/boot/vmlinuz kernel.img
sudo cp image/boot/initrd.img initrd.img
sudo cp Armbian_not_logged_in_yet image/root/.not_logged_in_yet
sudo mkdir image/opt/sky360
sudo cp requirements.txt image/opt/sky360/requirements.txt

sudo umount image
rm -rf image