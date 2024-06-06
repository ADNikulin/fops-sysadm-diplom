#----- Настройка сети и подсети
#   -- Внутрення сеть
resource "yandex_vpc_network" "fsd-network" {
  name        = "fsd-network"
  description = "Внутрення сеть"
}

resource "yandex_vpc_gateway" "cw-private-gateway" {
  name = "cw-private-gateway"
  shared_egress_gateway {}
}


resource "yandex_vpc_route_table" "vpc_route" {
  name       = "vpc_route"
  network_id = yandex_vpc_network.fsd-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.cw-private-gateway.id
  }
}

resource "yandex_vpc_subnet" "fsd-bastion-subnet" {
  name           = "fsd-bastion-subnet"
  v4_cidr_blocks = ["172.16.14.0/24"]
  zone           = var.location-zone_ru-central1-b
  network_id     = yandex_vpc_network.fsd-network.id
  description    = "Внутрення подсеть в которой лежит бастион хост"
}

resource "yandex_vpc_subnet" "fsd-internal-subnet-a" {
  name           = "fsd-internal-subnet-a"
  v4_cidr_blocks = ["172.16.15.0/24"]
  zone           = var.location-zone_ru-central1-a
  network_id     = yandex_vpc_network.fsd-network.id
  description    = "Внутрення подсеть которая находится в зоне А"
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "fsd-internal-subnet-b" {
  name           = "fsd-internal-subnet-b"
  v4_cidr_blocks = ["172.16.16.0/24"]
  zone           = var.location-zone_ru-central1-b
  network_id     = yandex_vpc_network.fsd-network.id
  description    = "Внутрення подсеть которая находится в зоне Б"
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "fsd-internal-subnet-d" {
  name           = "fsd-internal-subnet-d"
  v4_cidr_blocks = ["172.16.20.0/24"]
  zone           = var.location-zone_ru-central1-d
  network_id     = yandex_vpc_network.fsd-network.id
  description    = "Внутрення подсеть которая находится в зоне D"
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "fsd-external-subnet" {
  name           = "fsd-external-subnet"
  zone           = var.location-zone_ru-central1-b
  v4_cidr_blocks = ["172.16.17.0/24"]
  network_id     = yandex_vpc_network.fsd-network.id
  description    = "Внешняя подсеть находящаяся в зоне Б"
}

resource "yandex_vpc_subnet" "fsd-observability-subnet" {
  name           = "fsd-observability-subnet"
  zone           = var.location-zone_ru-central1-b
  network_id     = yandex_vpc_network.fsd-network.id
  v4_cidr_blocks = ["172.16.18.0/24"]
  description    = "подсеть для прометеуса и графаны"
  route_table_id = yandex_vpc_route_table.vpc_route.id
}
