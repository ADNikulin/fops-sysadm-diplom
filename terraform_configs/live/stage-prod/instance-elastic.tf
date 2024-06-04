#------------------------ prometheus --------------------------
resource "yandex_compute_instance" "elastic" {
  name               = "elastic-host"
  hostname           = "elastic-host"
  zone               = var.location-zone_ru-central1-b
  service_account_id = var.service_account_id
  description        = "elastic-host"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.image_id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.fsd-observability-subnet.id
    security_group_ids = [yandex_vpc_security_group.sg-elastic.id, yandex_vpc_security_group.sg-ssh-internal.id]
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
