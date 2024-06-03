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

resource "yandex_compute_instance" "bastion" {
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
    subnet_id          = var.servers_subnet_external_id
    nat                = true
    security_group_ids = [var.servers_security_external_group_id]
    ipv4               = true
    nat_ip_address     = var.ipv4_external-nat
  }

  network_interface {
    subnet_id          = var.servers_subnet_internal_id
    nat                = false
    security_group_ids = [var.servers_security_internal_group_id]
    ipv4               = true
    ip_address         = var.ipv4_internal-local
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
