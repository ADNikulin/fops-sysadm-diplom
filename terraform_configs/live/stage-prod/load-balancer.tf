resource "yandex_alb_http_router" "http_router-fsd_netology" {
  name = "http-router-fsd-netology"
  labels = {
    tf-label = "fsd_netology"
  }
}

resource "yandex_alb_backend_group" "backend_group-fsd_netology" {
  name = "backend-group-fsd-netology"

  http_backend {
    name             = "test-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_compute_instance_group.webservers.application_load_balancer[0].target_group_id]

    load_balancing_config {
      panic_threshold = 5
    }

    healthcheck {
      timeout          = "2s"
      interval         = "2s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
    #    http2 = "false"
  }
}

resource "yandex_alb_virtual_host" "vh_fsd_netology" {
  name           = "vh-fsd-netology"
  http_router_id = yandex_alb_http_router.http_router-fsd_netology.id
  route {
    name = "http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend_group-fsd_netology.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "lb-fsd_netology" {
  name               = "lb-fsd-netology"
  network_id         = yandex_vpc_network.fsd-network.id
  security_group_ids = [yandex_vpc_security_group.sg-load_balancer.id]

  allocation_policy {
    location {
      zone_id   = var.location-zone_ru-central1-a
      subnet_id = yandex_vpc_subnet.fsd-internal-subnet-a.id
    }

    location {
      zone_id   = var.location-zone_ru-central1-b
      subnet_id = yandex_vpc_subnet.fsd-internal-subnet-b.id
    }

    location {
      zone_id   = var.location-zone_ru-central1-d
      subnet_id = yandex_vpc_subnet.fsd-internal-subnet-d.id
    }
  }

  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http_router-fsd_netology.id
      }
    }
  }
  depends_on = [ 
    yandex_vpc_security_group_rule.sg-rule-load_balancer-healthchecks,
    yandex_vpc_security_group_rule.sg-rule-load_balancer-http
  ]
}
