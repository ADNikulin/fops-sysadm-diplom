resource "yandex_vpc_security_group_rule" "sg-rule-webservers-http" {
  security_group_binding = yandex_vpc_security_group.sg-webservers.id
  direction              = "ingress"
  description            = "allow port 80 "
  port                   = 80
  protocol               = "TCP"
  v4_cidr_blocks         = ["172.16.15.0/24", "172.16.16.0/24"]
}
