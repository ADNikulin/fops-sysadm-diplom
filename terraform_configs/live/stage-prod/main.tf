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

module "fsd-networks" {
  source                   = "./../../modules/networks"
  zone                     = var.zone
  network-name             = var.network-name
  subnet-name              = var.subnet-name
  v4_cidr_blocks           = var.v4_cidr_blocks
}

module "nginx-server-1" {
  source                   = "./../../modules/servers"
  core_fraction            = 20
  server-app-name          = "nginx-master"
  server-host-name         = "nginx-master"
  servers_subnet_id        = module.fsd-networks.subnet_id
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
}