terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
}

data "yandex_compute_image" "base" {
  family = var.server-os_family
}

resource "yandex_compute_instance" "instance" {
  name        = var.server-app-name
  hostname    = var.server-host-name
  zone        = var.server-zone-location
  platform_id = "standard-v3"
  description = var.server-app-description

  resources {
    cores         = var.server-core_numbers
    core_fraction = var.server-core_fraction
    memory        = var.server-memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.image_id
      size     = var.server-disk_memory
      type     = var.server-disk_type
    }
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id          = var.servers_subnet_id
    nat                = var.nat
    security_group_ids = var.sg_group_ids
    ipv4               = true
    ip_address         = var.ipv4_internal
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
