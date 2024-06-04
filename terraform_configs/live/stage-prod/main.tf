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

data "yandex_compute_image" "base" {
  family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "webserver" {
  family = "lemp"
}