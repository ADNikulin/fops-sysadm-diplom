resource "yandex_vpc_security_group_rule" "sg-rule-bastion-external" {
  security_group_binding = yandex_vpc_security_group.sg-bastion-external.id
  direction              = "ingress"
  description            = "Allow SSH"
  port                   = 22
  protocol               = "TCP"
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "sg-rule-bastion-external-egress" {
  security_group_binding = yandex_vpc_security_group.sg-bastion-external.id
  direction              = "egress"
  description            = "outgoing"
  port                   = 22
  protocol               = "TCP"
  security_group_id      = yandex_vpc_security_group.sg-ssh-internal.id
}
