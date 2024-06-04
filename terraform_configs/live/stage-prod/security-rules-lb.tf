resource "yandex_vpc_security_group_rule" "sg-rule-load_balancer-https" {
  security_group_binding = yandex_vpc_security_group.sg-load_balancer.id
  direction              = "ingress"
  description            = "incoming requests from web"
  port                   = 443
  protocol               = "TCP"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "sg-rule-load_balancer-http" {
  security_group_binding = yandex_vpc_security_group.sg-load_balancer.id
  direction              = "ingress"
  description            = "incoming requests from web"
  port                   = 80
  protocol               = "TCP"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "sg-rule-load_balancer-healthchecks" {
  security_group_binding = yandex_vpc_security_group.sg-load_balancer.id
  direction              = "ingress"
  description            = "allow healthchecks"
  protocol               = "TCP"
  port                   = 30080
  predefined_target      = "loadbalancer_healthchecks"
}

resource "yandex_vpc_security_group_rule" "sg-rule-load_balancer-egress" {
  security_group_binding = yandex_vpc_security_group.sg-load_balancer.id
  direction              = "egress"
  description            = "outgoing"
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}
