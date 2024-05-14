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

module "fsd-networks" {
  source       = "./../../modules/networks/network"
  zone         = var.zone
  network-name = var.network-name
}

module "fsd-subnet-a" {
  source         = "../../modules/networks/subnet"
  network_id     = module.fsd-networks.network_id
  v4_cidr_blocks = var.v4_cidr_blocks-a
  subnet-name    = var.subnet-a-name
  zone           = var.location-zone_ru-central1-a
}

module "fsd-subnet-b" {
  source         = "../../modules/networks/subnet"
  network_id     = module.fsd-networks.network_id
  v4_cidr_blocks = var.v4_cidr_blocks-b
  subnet-name    = var.subnet-b-name
  zone           = var.location-zone_ru-central1-b
}

#--- begin: setup nginx servers
module "nginx-server-1" {
  source                    = "./../../modules/servers"
  core_fraction             = 20
  server-app-name           = "nginx-master"
  server-host-name          = "nginx-master"
  servers_subnet_id         = module.fsd-subnet-a.subnet_id
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
  server-zone-location      = var.location-zone_ru-central1-a
}

module "nginx-server-2" {
  source                    = "./../../modules/servers"
  core_fraction             = 20
  server-app-name           = "nginx-slave"
  server-host-name          = "nginx-slave"
  servers_subnet_id         = module.fsd-subnet-b.subnet_id
  path_to_metadata_user_ssh = var.path_to_metadata_user_ssh
  server-zone-location      = var.location-zone_ru-central1-b
}
#--- end: setup nginx servers

#--- begin: settup target group
resource "yandex_alb_target_group" "nginx-target-group" {
  name = "nginx-target-group"

  target {
    ip_address = module.nginx-server-1.internal_ip_address_server
    subnet_id  = module.nginx-server-1.server_subnet_id
  }

  target {
    ip_address = module.nginx-server-2.internal_ip_address_server
    subnet_id  = module.nginx-server-2.server_subnet_id
  }
}
#--- end: settup target group

#--- Begin: settup Backend -----
resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.nginx-target-group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}
#--- end: settup Backend -----

#--- begin: HTTP router -----
resource "yandex_alb_http_router" "http-router" {
  name          = "http-router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "nginx-virtual-host" {
  name                    = "nginx-virtual-host"
  http_router_id          = yandex_alb_http_router.http-router.id
  route {
    name                  = "nginx-way"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group.id
        timeout           = "60s"
      }
    }
  }
}    
#--- end: HTTP router -----

#--- begin: L-7 Balance -----
resource "yandex_alb_load_balancer" "nginx-balancer" {
  name        = "nginx-balancer"
  network_id  = module.fsd-networks.network_id
  security_group_ids = [yandex_vpc_security_group.balance.id]

  allocation_policy {
    location {
      zone_id   = var.location-zone_ru-central1-a
      subnet_id = module.fsd-subnet-a.subnet_id
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}

#--- end: L-7 Balance -----