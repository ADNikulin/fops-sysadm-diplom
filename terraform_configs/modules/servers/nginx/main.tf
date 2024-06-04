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

data "yandex_compute_image" "webserver" {
  family = "lemp"
}

resource "yandex_compute_instance_group" "nginx" {
  name                = var.server-app-name
  deletion_protection = false
  service_account_id  = var.service_account_id

  instance_template {
    platform_id = "standard-v3"
    name        = "{var.server-host-name} {instance.short_id}"
    hostname    = "{var.server-host-name} {instance.short_id}"

    resources {
      cores         = 2
      core_fraction = var.core_fraction
      memory        = 1
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.webserver.image_id
        size     = 20
        type     = "network-hdd"
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      nat                = false
      security_group_ids = [var.servers_security_internal_group_id]
      ipv4               = true
      ipv6               = false
    }

    metadata = {
      user-data = "${file(var.path_to_metadata_user_ssh)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
    max_deleting    = 1
    max_creating    = 3
  }
}
