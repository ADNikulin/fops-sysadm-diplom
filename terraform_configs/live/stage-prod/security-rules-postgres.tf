resource "yandex_vpc_security_group_rule" "sg-rule-prometheus-postgres" {
  security_group_binding = yandex_vpc_security_group.sg-postgres.id
  direction              = "ingress"
  description            = "prometheus - grafana"
  port                   = 6432
  protocol               = "TCP"
  security_group_id      = yandex_vpc_security_group.sg-prometheus.id
}
