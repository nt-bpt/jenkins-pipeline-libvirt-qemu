#!/bin/bash
echo 'Downloading the ISO image...'
wget https://dl.armbian.com/orangepi5-plus/Noble_vendor_server-kisak -O Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img.xz

echo 'Checking the SHA256 checksum...'
shasum -a 256 -c img.xz.sha
echo 'unxz the image...'
unxz Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img.xz

echo 'Mounting the image...'
sudo mkdir image
echo 'Calculating the offset...'
OFFSET=$(fdisk -l Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img | grep '^Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img' | awk '{print $2 * 512}')
echo 'Offset is' $OFFSET
echo 'Mounting the image...'
sudo mount -o loop,offset=$OFFSET Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img image

echo 'Copying the kernel and initrd...'
sudo cp image/boot/vmlinuz kernel.img
echo 'Copying the initrd...'
sudo cp image/boot/initrd.img initrd.img
echo 'Copying the initial Armbian boot configuration...'
sudo cp Armbian_not_logged_in_yet image/root/.not_logged_in_yet
echo 'Creating Sky360 /opt/sky360 directory...'
sudo mkdir image/opt/sky360
echo 'Copying the requirements.txt file...'
sudo cp requirements.txt image/opt/sky360/requirements.txt

echo 'Unmounting the image...'
sudo umount image
echo 'Removing the image directory...'
rm -rf image