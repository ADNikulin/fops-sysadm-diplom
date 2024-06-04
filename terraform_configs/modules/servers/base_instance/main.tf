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

resource "yandex_compute_instance" "instance" {
  name        = var.server-app-name
  hostname    = var.server-host-name
  zone        = var.server-zone-location
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = var.core_fraction
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ecgtorub9r4609man"
      size     = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = var.servers_subnet_id
    nat                = false
    security_group_ids = [var.sg_group_id]
    ipv4               = true
    ip_address         = var.ipv4_internal
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
