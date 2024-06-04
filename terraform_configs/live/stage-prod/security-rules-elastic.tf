#--------- elastic ------------------
resource "yandex_vpc_security_group_rule" "sg-rule-elastic-kibana" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "ingress"
  description            = "elastic - kibana"
  security_group_id      = yandex_vpc_security_group.sg-kibana.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "sg-rule-elastic-webservices" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "ingress"
  description            = "elastic - logs webservices"
  security_group_id      = yandex_vpc_security_group.sg-webservers.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "sg-rule-elastic-prometheus" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "ingress"
  description            = "elastic - logs prometheus"
  security_group_id      = yandex_vpc_security_group.sg-prometheus.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "sg-rule-elastic-grafana" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "ingress"
  description            = "elastic - logs grafana"
  security_group_id      = yandex_vpc_security_group.sg-grafana.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "sg-rule-elastic-metrics" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "ingress"
  description            = "elastic - prometheus metrics"
  security_group_id      = yandex_vpc_security_group.sg-prometheus.id
  protocol               = "TCP"
  port                   = 9100
}

resource "yandex_vpc_security_group_rule" "sg-rule-elastic-egress" {
  security_group_binding = yandex_vpc_security_group.sg-elastic.id
  direction              = "egress"
  description            = "outgoing"
  protocol               = "ANY"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}
