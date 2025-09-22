packer {
  required_plugins {
    yandex = {
      version = ">= 0.0.0"
      source  = "github.com/hashicorp/yandex"
    }
  }
}

variable "folder_id" {
  type    = string
  default = "${env("YC_BUILD_FOLDER_ID")}"
}

variable "service_account_key_file" {
  type    = string
  default = "${env("YC_BUILD_SERVICE_ACCOUNT_SECRET")}"
}

variable "subnet_id" {
  type    = string
  default = "${env("YC_BUILD_SUBNET")}"
}

variable "use_ip_v4_nat" {
  type    = string
  default = "true"
}

variable "zone" {
  type    = string
  default = "${env("YC_ZONE")}"
}

variable "user"{
  type    = string
  default = "arch"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


source "yandex" "archdirty" {
  disk_size_gb      = 10
  disk_type         = "network-hdd"
  folder_id         = "${var.folder_id}"
  service_account_key_file  = "${var.service_account_key_file}"
  subnet_id                 = "${var.subnet_id}"
  ssh_clear_authorized_keys = true
  ssh_username              = "${var.user}"
  use_ipv4_nat              = "${var.use_ip_v4_nat}"
  zone                      = "${var.zone}"
  temporary_key_pair_type   = "ed25519"

  image_description = "arch"
  image_family      = "arch"
  image_name = "arch-docker-${local.timestamp}"

  source_image_family       = "arch-docker"
  source_image_folder_id = "${var.folder_id}"
}


build {
  sources = ["source.yandex.archdirty"]
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    pause_before    = "5s"
    scripts         = ["scripts/install.sh"]
  }


/* Prepare directories
https://developer.hashicorp.com/packer/docs/provisioners/file
First, the destination directory must already exist. If you need to create it, use a shell provisioner just prior to the file provisioner in order to create the directory. If the destination directory does not exist, the file provisioner may succeed, but it will have undefined results.*/
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /etc/scripts"]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /etc/nft"]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /etc/ssh/sshd_conf.d"]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /etc/ssh/ssh_config.d/"]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /usr/lib/systemd/system/"]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["mkdir -p /var/lib/cloud/scripts/per-instance/"]
  }
  provisioner "shell" {
    inline = ["mkdir -p /tmp/config"]
  }


  // 'arch' user doesn't have permissions to copy to the needed destination.
  // copy to temp and then move
  provisioner "file" {
    source = "config/etc"
    destination = "/tmp/config"
  }
  provisioner "file" {
    source = "config/var"
    destination = "/tmp/config"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    inline = ["cp -r /tmp/config/* /", "rm -rf /tmp/config"]
  }


  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} bash '{{ .Path }}'"
    pause_before    = "5s"
    scripts         = ["scripts/configure.sh", "scripts/cleanup.sh"]
  }


  post-processor "manifest" {
    output     = "${path.cwd}/manifest.json"
    strip_path = true
  }
}
