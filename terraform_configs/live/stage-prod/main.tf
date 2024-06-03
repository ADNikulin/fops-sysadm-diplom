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

resource "yandex_vpc_security_group" "sg_bastion-internal-a" {
  name = "sg_bastion-internal-a"
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

module "bastion-host" {
  source = "../../modules/servers/bastion"
  ipv4_internal-local = "172.16.16.254"
  ipv4_external-nat = "51.250.106.195"
  server-app-name = "bastion"
  server-host-name = "bastion"
  server-zone-location = var.location-zone_ru-central1-b
  servers_subnet_external_id = yandex_vpc_subnet.fsd-external-subnet.id
  servers_subnet_internal_id = yandex_vpc_subnet.fsd-internal-subnet-b.id
  servers_security_external_group_id = yandex_vpc_security_group.sg_bastion-external.id
  servers_security_internal_group_id = yandex_vpc_security_group.sg_bastion-internal.id
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
}

module "nginx-b" {
  source = "../../modules/servers/nginx"
  server-app-name = "nginx-b"
  server-host-name = "nginx-b"
  server-zone-location = var.location-zone_ru-central1-b
  servers_subnet_internal_id = yandex_vpc_subnet.fsd-internal-subnet-b.id
  servers_security_internal_group_id = yandex_vpc_security_group.sg_bastion-internal.id
  ipv4_internal-local = "172.16.16.10"
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
}

module "nginx-a" {
  source = "../../modules/servers/nginx"
  server-app-name = "nginx-a"
  server-host-name = "nginx-a"
  server-zone-location = var.location-zone_ru-central1-a
  servers_subnet_internal_id = yandex_vpc_subnet.fsd-internal-subnet-a.id
  servers_security_internal_group_id = yandex_vpc_security_group.sg_bastion-internal.id
  ipv4_internal-local = "172.16.15.10"
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
}

