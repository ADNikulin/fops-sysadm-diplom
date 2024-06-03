terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.13"
}

provider "yandex" {
  zone                     = var.zone
}

# Подготовка виртуальной машины Ubuntu core 2 memory 2 20% core using 
resource "yandex_compute_instance" "server" {
  name        = "${var.server-app-name}-server"
  hostname    = var.server-host-name
  zone        = var.server-zone-location
  platform_id = "standard-v3"
  

  # вычислительные мощности машины
  resources {
    core_fraction = var.core_fraction
    cores         = 2
    memory        = 2
  }

  # какой образ будем грузить, по хорошему надо получить из самого яндекса
  boot_disk {
    initialize_params {
      # image_id = data.yandex_compute_image.ubuntu_image
      image_id = "fd8g5aftj139tv8u2mo1"
    }
  }

  network_interface {
    subnet_id = var.servers_subnet_id
    nat       = true
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}