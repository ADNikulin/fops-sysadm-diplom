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

# Подсеть
resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.v4_cidr_blocks]
  name           = var.subnet-name
  zone           = var.zone
  network_id     = var.network_id
}