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

# Сеть
resource "yandex_vpc_network" "network-main" {
  name = var.network-name
}
