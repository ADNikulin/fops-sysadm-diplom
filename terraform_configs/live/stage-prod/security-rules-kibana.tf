resource "yandex_vpc_security_group_rule" "sg-rule-kibana-ui" {
  security_group_binding = yandex_vpc_security_group.sg-kibana.id
  direction              = "ingress"
  description            = "kibana ui"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
  port                   = 5601
}

resource "yandex_vpc_security_group_rule" "sg-rule-kibana-metrics" {
  security_group_binding = yandex_vpc_security_group.sg-kibana.id
  direction              = "ingress"
  description            = "kibana node metrics"
  security_group_id      = yandex_vpc_security_group.sg-prometheus.id
  protocol               = "TCP"
  port                   = 9100
}

resource "yandex_vpc_security_group_rule" "sg-rule-kibana-egress" {
  security_group_binding = yandex_vpc_security_group.sg-kibana.id
  direction              = "egress"
  description            = "outgoing"
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}
