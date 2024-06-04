resource "yandex_vpc_security_group_rule" "sg-rule-prometheus-grafana" {
  security_group_binding = yandex_vpc_security_group.sg-prometheus.id
  direction              = "ingress"
  description            = "prometheus - grafana"
  port                   = 9090
  protocol               = "TCP"
  security_group_id      = yandex_vpc_security_group.sg-grafana.id
}

resource "yandex_vpc_security_group_rule" "sg-rule-prometheus-egress" {
  security_group_binding = yandex_vpc_security_group.sg-prometheus.id
  direction              = "egress"
  description            = "outgoing"
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}
