packer {
  required_plugins {
    qemu {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "iso_url" {
  default = "https://dl.armbian.com/orangepi5-plus/Noble_vendor_server-kisak"
}

variable "iso_checksum" {
  default = "908cfea539b6449a932582a03c5ccc2af6561c5625fc9c5b88fc320e07dd7c63"
}

variable "local_image_path" {
  default = "Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img"
}

source "qemu" "armbian-ubuntu-noble-arm64" {
  iso_url            = var.local_image_path
  iso_checksum       = var.iso_checksum
  output_directory   = "armbian-ubuntu-noble-arm64"
  vm_name            = "armbian-ubuntu-noble-arm64"
  disk_size          = "10000"
  format             = "qcow2"
  headless           = true
  http_directory     = "http"
  ssh_username       = "skytester"
  ssh_password       = "sky360"
  ssh_wait_timeout   = "30m"
  ssh_pty            = true
  boot_wait          = "10s"
  boot_command       = [
    "<enter><wait>",
    "<f6><esc><wait>",
    "console=ttyS0,115200n8 root=/dev/vda1<enter>"
  ]
  qemu_binary = "qemu-system-aarch64"
  qemuargs = [
    ["-m", "8G"],
    ["-cpu", "max"],
    ["-smp", "2"],
    ["-M", "virt"],
    ["-kernel", "kernel.img"],
    ["-initrd", "initrd.img"],
    ["-drive", "if=none,file=${var.local_image_path},format=raw,id=hd0"],
    ["-append", "earlyprintk loglevel=8 root=/dev/vda1"],
    ["-device", "virtio-blk-device,drive=hd0"],
    ["-netdev", "user,id=net0"],
    ["-device", "virtio-net-device,netdev=net0"],
    ["-serial", "mon:stdio"]
  ]
}

build {
  sources = ["source.qemu.armbian-arm64"]
  
  provisioner "shell" {
    inline = [
      "echo 'Provisioning...'",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo atp-get install -y ufw",
      "sudo ufw allow 22",
      "sudo apt-get install -y net-tools",
      "sudo apt-get install -y cmake",
      "sudo apt-get install -y build-essential",
      "sudo apt-get install -y python3",
      "sudo apt-get install -y python3-pip",
      "sudo apt-get install -y python3-venv",
      "sudo apt-get install -y python3-dev",
      "sudo apt-get install -y python3-setuptools",
      "sudo apt-get install -y python3-wheel",
      "sudo python3 -m venv /opt/sky360/.venv",
      "sudo chown -R skytester /opt/sky360",
      "sudo chown -R skytester /opt/sky360/.venv",
      "sudo chgrp -R skytester /opt/sky360",
      "sudo chgrp -R skytester /opt/sky360/.venv",
      "source /opt/sky360/.venv/bin/activate && python3 -m pip install -r /opt/sky360/requirements.txt",
    ]
  }
}