#--------------------- NGINX ------------------------------
resource "yandex_compute_instance_group" "webservers" {
  name                = "webservers"
  deletion_protection = false
  service_account_id  = var.service_account_id

  application_load_balancer {
    target_group_name = "fsd-netology"
  }

  instance_template {
    platform_id        = "standard-v3"
    name               = "nginx-{instance.short_id}-webserver-host"
    hostname           = "nginx-{instance.short_id}-webserver-host"
    service_account_id = var.service_account_id

    resources {
      cores         = 2
      core_fraction = 20
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
      preemptible = var.preemptible
    }

    network_interface {
      # delete
      nat        = var.nat_for_private
      network_id = yandex_vpc_network.fsd-network.id
      subnet_ids = [
        yandex_vpc_subnet.fsd-internal-subnet-a.id,
        yandex_vpc_subnet.fsd-internal-subnet-b.id,
        yandex_vpc_subnet.fsd-internal-subnet-d.id
      ]
      security_group_ids = [
        yandex_vpc_security_group.sg-webservers.id,
        yandex_vpc_security_group.sg-ssh-internal.id
      ]
      ipv4 = true
      ipv6 = false
    }

    metadata = {
      user-data = "${file(var.path_to_metadata_user_ssh)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.location-zone_ru-central1-a, var.location-zone_ru-central1-b, var.location-zone_ru-central1-d]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
    max_deleting    = 1
    max_creating    = 2
  }
}
