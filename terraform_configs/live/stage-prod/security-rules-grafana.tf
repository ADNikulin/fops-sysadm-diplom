resource "yandex_vpc_security_group_rule" "sg-rule-grafana-ui" {
  security_group_binding = yandex_vpc_security_group.sg-grafana.id
  direction              = "ingress"
  description            = "grafana ui"
  port                   = 3000
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "sg-rule-grafana-metrics" {
  security_group_binding = yandex_vpc_security_group.sg-grafana.id
  direction              = "ingress"
  description            = "grafana metrics"
  port                   = 9100
  protocol               = "TCP"
  security_group_id      = yandex_vpc_security_group.sg-prometheus.id
}

resource "yandex_vpc_security_group_rule" "sg-rule-grafana-egress" {
  security_group_binding = yandex_vpc_security_group.sg-grafana.id
  direction              = "egress"
  description            = "outgoing"
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}
