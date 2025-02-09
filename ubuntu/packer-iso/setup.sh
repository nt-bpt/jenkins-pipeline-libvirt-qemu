#!/bin/bash
echo 'Downloading vendor image to boot and current image to extract kernel and initrd...'
wget https://dl.armbian.com/orangepi5-plus/Noble_vendor_server-kisak -O Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img.xz

echo 'Checking the SHA256 checksum...'
shasum -a 256 -c vendor.img.xz.sha
echo 'unxz the image...'
unxz Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img.xz

wget https://dl.armbian.com/orangepi5-plus/Noble_current_server-kisak -O Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img.xz

echo 'Checking the SHA256 checksum...'
shasum -a 256 -c current.img.xz.sha
echo 'unxz the image...'
unxz Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img.xz


# mainline kernel setup
echo 'Mounting the mainline kernel current image to extract the kernel and initrd so we can boot with qemu...'
sudo mkdir image
echo 'Calculating the offset...'
OFFSET=$(fdisk -l Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img | grep '^Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img' | awk '{print $2 * 512}')
echo 'Offset is' $OFFSET
echo 'Mounting the image...'
sudo mount -o loop,offset=$OFFSET Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img image

echo 'Copying the kernel and initrd...'
sudo cp image/boot/vmlinuz kernel.img
echo 'Copying the initrd...'
sudo cp image/boot/initrd.img initrd.img

echo 'Unmounting the image...'
sudo umount image

# vendor image setup
echo 'Mounting the vendor image to copy required setup files into the image...'
sudo mkdir image
echo 'Calculating the offset...'
OFFSET=$(fdisk -l Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img | grep '^Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img' | awk '{print $2 * 512}')
echo 'Offset is' $OFFSET
echo 'Mounting the image...'
sudo mount -o loop,offset=$OFFSET Armbian_24.11.2_Orangepi5-plus_noble_vendor_6.1.75-kisak.img image

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
echo 'Removing the current mainline kernel image...'
rm Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img