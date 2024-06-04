resource "yandex_compute_instance" "bastion" {
  name               = "bastion-host"
  hostname           = "bastion-host"
  zone               = var.location-zone_ru-central1-b
  service_account_id = var.service_account_id
  description        = "bastion-host"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.fsd-bastion-subnet.id
    nat                = true
    ip_address         = "172.16.14.254"
    security_group_ids = [yandex_vpc_security_group.sg-bastion-external.id]
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
