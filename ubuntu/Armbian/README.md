### qemu command to start image

```bash
qemu-system-aarch64 -m 8G -cpu max -smp 2 -M virt -kernel kernel.img -initrd initrd.img -drive if=none,file=Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img,format=raw,id=hd0 -append 'earlyprintk loglevel=8 root=/dev/vda1' -device VGA -device virtio-blk-device,drive=hd0 -netdev type=user,id=net0 -device virtio-net-device,netdev=net0
```

### mount command to alter image

```bash
OFFSET=$(fdisk -l Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img | grep '^Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img' | awk '{print $2 * 512}')

sudo mount -o loop,offset=$OFFSET Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img image

sudo mount -o loop,offset=16777216 Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img /mnt/orange
```