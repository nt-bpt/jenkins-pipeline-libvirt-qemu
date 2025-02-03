packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}


variable "local_image_path" {
  default = "Armbian_24.11.2_Orangepi5-plus_noble_current_6.12.0-kisak.img"
}

variable "default_username" {
  default = "skytester"
}

variable "default_password" {
  default = "9wrA3D3vtjRtL"
}

source "qemu" "armbian-ubuntu-noble-arm64" {
  iso_url            = var.local_image_path
  iso_checksum       = "none"
  disk_image         = "true"
  output_directory   = "armbian-ubuntu-noble-arm64"
  vm_name            = "armbian-ubuntu-noble-arm64"
  disk_size          = "10000"
  format             = "qcow2"
  headless           = true
  http_directory     = "http"
  ssh_username       = var.default_username
  ssh_password       = var.default_password
  ssh_wait_timeout   = "15m"
  ssh_pty            = true
  boot_wait          = "300s"
  boot_command       = [
    "<wait60>root<enter><wait5>",
    "${var.default_password}<enter><wait120>",
  ]
  qemu_binary = "qemu-system-aarch64"
  qemuargs = [
    ["-m", "8G"],
    ["-cpu", "max"],
    ["-smp", "2"],
    ["-machine", "virt"],
    ["-kernel", "kernel.img"],
    ["-initrd", "initrd.img"],
    ["-drive", "if=none,file=${var.local_image_path},format=raw,id=hd0"],
    ["-append", "earlyprintk loglevel=8 root=/dev/vda1"],
  ]
}

build {
  sources = ["source.qemu.armbian-ubuntu-noble-arm64"]
  
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