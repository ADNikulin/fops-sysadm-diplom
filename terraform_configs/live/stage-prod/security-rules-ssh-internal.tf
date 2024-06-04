resource "yandex_vpc_security_group_rule" "sg-rule-ssh-internal" {
  security_group_binding = yandex_vpc_security_group.sg-ssh-internal.id
  direction              = "ingress"
  description            = "allow SSH from 172.16.14.254"
  port                   = 22
  protocol               = "TCP"
  v4_cidr_blocks         = ["172.16.14.254/32"]
}

resource "yandex_vpc_security_group_rule" "sg-rule-ssh-internal-egress" {
  security_group_binding = yandex_vpc_security_group.sg-ssh-internal.id
  direction              = "egress"
  description            = "Allow SSH"
  port                   = 22
  protocol               = "TCP"
  predefined_target      = "self_security_group"
}
