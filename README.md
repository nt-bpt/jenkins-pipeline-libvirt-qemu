# Armbian Ubuntu with Packer


## Setup build/host system

#### Install qemu
Follow these setup to setup qemu-system-aarch64 on ubuntu 22.04 [https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu](https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu)

```bash
sudo apt install qemu-system-arm
```

#### Install Packer and setup hashicorp ppa
[https://developer.hashicorp.com/packer/install#linux](https://developer.hashicorp.com/packer/install#linux)

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
```


#### Accept all host keys

Fingerprints will change per quest OS you create and ssh needs to be able to login without having to accept the fingerprint. Packer does not appear to recognize this step and assumes you'll be using a shared key or a different configuration.

[https://askubuntu.com/questions/87449/how-to-disable-strict-host-key-checking-in-ssh](https://askubuntu.com/questions/87449/how-to-disable-strict-host-key-checking-in-ssh)

For the user that will be running packer you'll need to add the following to ~/.ssh/config
```bash
Host *
    StrictHostKeyChecking no
```

Update permissions to read only
```bash
sudo chmod 400 ~/.ssh/config
```

### Building the image
Run the following commands. The setup.sh script will ask for your su login since it needs to mount a loopback device to modify the image before we will run it. We will also extract the kernel and initrd images from /boot to be used with the qemu command.

```bash
cd ubuntu/packer-iso && packer init armbianUbuntu.pkr.hcl
./setup.sh
packer build armbianUbuntu.pkr.hcl
```

The build process could take several hours depending on your system. If you want to monitor the build process you can use vnc to watch the initial boot commands. Watch the packer build process output for the vnc port. If you're running this on a remote machine you'll need to bind vnc to 0.0.0.0 . You can do this by adding the following setting to the source configuration for armbian-ubuntu-noble-arm64 in armbianUbuntu.pkr.hcl

```bash
vnc_bind_address   = "0.0.0.0" 
```

When the build is complete you'll need to convert your image back to a format that can be burned onto an sdcard.


```bash
qemu-img convert -O raw armbian-ubuntu-noble-arm64/armbian-ubuntu-noble-arm64 sddisk.img 
```

