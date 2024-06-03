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

#----- Настройка сети и подсети
#   -- Внутрення сеть
resource "yandex_vpc_network" "fsd-internal-network" {
  name = "fsd-internal-network"
  description = "Внутрення сеть"
}

#   -- Внешняя сеть
resource "yandex_vpc_network" "fsd-external-network" {
  name = "fsd-external-network"
  description = "Внешняя сеть"
}

resource "yandex_vpc_subnet" "fsd-internal-subnet-a" {
  name = "fsd-internal-subnet-a"
  v4_cidr_blocks = ["172.16.15.0/24"]
  zone = var.location-zone_ru-central1-a
  network_id = yandex_vpc_network.fsd-internal-network.id
  description = "Внутрення подсеть которая находится в зоне А"
}

resource "yandex_vpc_subnet" "fsd-internal-subnet-b" {
  name = "fsd-internal-subnet-b"
  v4_cidr_blocks = ["172.16.16.0/24"]
  zone = var.location-zone_ru-central1-b
  network_id = yandex_vpc_network.fsd-internal-network.id
  description = "Внутрення подсеть которая находится в зоне Б"
}

resource "yandex_vpc_subnet" "fsd-external-subnet" {
  name = "fsd-external-subnet"
  zone = var.location-zone_ru-central1-b
  v4_cidr_blocks = ["172.16.17.0/28"]
  network_id = yandex_vpc_network.fsd-external-network.id
  description = "Внешняя подсеть находящаяся в зоне Б"
}

resource "yandex_vpc_security_group" "sg_bastion-external" {
  name = "sg_bastion-external"
  network_id = yandex_vpc_network.fsd-external-network.id
  description = "Группа безопасности для внешнего доступа"
  
  ingress {
    port = 22
    protocol = "TCP"
    description = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_bastion-internal" {
  name = "sg_bastion-internal"
  network_id = yandex_vpc_network.fsd-internal-network.id
  description = "Группа безопасности для внутреннего доступа"
  
  ingress {
    port = 22
    protocol = "TCP"
    description = "Allow SSH from 172.16.16.254"
    v4_cidr_blocks = ["172.16.16.254/32"]
  }

  egress {
    port = 22
    protocol = "TCP"
    description = "Allow SSH"
    predefined_target = "self_security_group"
  }
}

resource "yandex_compute_instance" "bastion" {
  name = "bastion"
  hostname = "bastion"
  zone = var.location-zone_ru-central1-b
  platform_id = "standard-v3"

  resources {
    cores = 2
    core_fraction = 20
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ecgtorub9r4609man"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.fsd-external-subnet.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg_bastion-external.id]
    ipv4 = true
    nat_ip_address = "51.250.106.195"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.fsd-internal-subnet-b.id
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg_bastion-internal.id]
    ipv4 = true
    ip_address = "172.16.16.254"
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}

resource "yandex_compute_instance" "testvm" {
  name = "testvm"
  hostname = "testvm"
  zone = var.location-zone_ru-central1-b
  platform_id = "standard-v3"

  resources {
    cores = 2
    core_fraction = 20
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ecgtorub9r4609man"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.fsd-internal-subnet-b.id
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg_bastion-internal.id]
    ipv4 = true
  }

  metadata = {
    user-data = "${file(var.path_to_metadata_user_ssh)}"
  }
}
