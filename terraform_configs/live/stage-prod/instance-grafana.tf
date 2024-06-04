resource "yandex_compute_instance" "grafana" {
  name               = "grafana-host"
  hostname           = "grafana-host"
  zone               = var.location-zone_ru-central1-b
  service_account_id = var.service_account_id
  description        = "grafana-host + alertmanager"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.image_id
      size     = 20
      type     = "network-ssd"
    }
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.fsd-external-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-grafana.id, yandex_vpc_security_group.sg-ssh-internal.id]
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
