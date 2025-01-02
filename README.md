# jenkins-pipeline-libvirt-qemu
Simple cloud-init and packer configurations for qemu to setup a base image

Follow these setup to setup qemu-system-aarch64 on ubuntu 22.04 [https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu](https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu)

### Setting up seed image to configure base image
'''
genisoimage -output seed.iso -volid cidata -joliet -rock cloud-init
'''

### Setting up the base image and boot image
wget [https://cloud-images.ubuntu.com/noble/current/jammy-server-cloudimg-arm64.img](https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu)

'''
qemu-img create -f qcow2 -b jammy-server-cloudimg-arm64.img -F qcow2 boot-disk.img 20G
'''

### building the base image with cloud-init

'''
qemu-system-aarch64 -m 2048 -cpu cortex-a76 -smp 2 -M virt -drive if=pflash,format=raw,file=QEMU_EFI-pflash.raw,readonly=on -drive if=pflash,format=raw,file=QEMU_VARS-pflash.raw -drive if=none,file=boot-disk.img,format=qcow2,id=hd0 -device virtio-blk-device,drive=hd0 -cdrom seed.iso -boot d -netdev type=user,id=net0 -device virtio-net-device,netdev=net0
'''

### starting after cloud-init is finished
'''
qemu-system-aarch64 -m 2048 -cpu cortex-a76 -smp 2 -M virt -drive if=pflash,format=raw,file=QEMU_EFI-pflash.raw,readonly=on -drive if=pflash,format=raw,file=QEMU_VARS-pflash.raw -drive if=none,file=boot-disk.img,format=qcow2,id=hd0 -device virtio-blk-device,drive=hd0 -netdev type=user,id=net0 -device virtio-net-device,netdev=net0
'''
