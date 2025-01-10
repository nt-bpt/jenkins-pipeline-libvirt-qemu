# jenkins-pipeline-libvirt-qemu
Simple cloud-init and packer configurations for qemu to setup a base image

Follow these setup to setup qemu-system-aarch64 on ubuntu 22.04 [https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu](https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu)

```
sudo apt install qemu-system-arm
```
```
git clone https://github.com/nt-bpt/jenkins-pipeline-libvirt-qemu.git && cd jenkins-pipeline-libvirt-qemu
```
```
truncate -s 64m varstore.img
```
```
truncate -s 64m efi.img
```
```
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=efi.img conv=notrunc
```

### Setting up seed image to configure base image
```
genisoimage -output seed.iso -volid cidata -joliet -rock ubuntu/cloud-init
```

### Setting up the base image and boot image
```
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img
```
```
qemu-img create -f qcow2 -b jammy-server-cloudimg-arm64.img -F qcow2 boot-disk.img 20G
```

### building the base image with cloud-init

```
qemu-system-aarch64 -m 2048 -cpu max -smp 2 -M virt -drive if=pflash,format=raw,file=efi.img,readonly=on -drive if=pflash,format=raw,file=varstore.img -drive if=none,file=boot-disk.img,format=qcow2,id=hd0 -device virtio-blk-device,drive=hd0 -cdrom seed.iso -boot d -netdev type=user,id=net0 -device virtio-net-device,netdev=net0
```
NOTE: If you're on a recent version of qemu use '-cpu cortex-a76' instead of max

### starting after cloud-init is finished
remove the seed image drive after initial startup. 
```
qemu-system-aarch64 -m 2048 -cpu max -smp 2 -M virt -drive if=pflash,format=raw,file=efi.img,readonly=on -drive if=pflash,format=raw,file=varstore.img -drive if=none,file=boot-disk.img,format=qcow2,id=hd0 -device virtio-blk-device,drive=hd0 -netdev type=user,id=net0 -device virtio-net-device,netdev=net0
```
NOTE: If you're on a recent version of qemu use '-cpu cortex-a76' instead of max

login with username: skytester password: sky360

Disable cloud-init startup
[https://cloudinit.readthedocs.io/en/latest/howto/disable_cloud_init.html#method-1-text-file](https://cloudinit.readthedocs.io/en/latest/howto/disable_cloud_init.html#method-1-text-file)

set the following inside the image
```
touch /etc/cloud/cloud-init.disabled
```

### Write to a flash sd
covert the image to a raw format
```
qemu-img convert -f qcow2 boot-disk.qcow2 -f raw sddisk.img
```
