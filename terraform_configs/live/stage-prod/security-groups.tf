#--------- SSH GROUPS ------------------
resource "yandex_vpc_security_group" "sg-ssh-internal" {
  description = "allow trafic on ssh from bastion host"
  name        = "sg-ssh-internal"
  network_id  = yandex_vpc_network.fsd-network.id
}

resource "yandex_vpc_security_group" "sg-bastion-external" {
  name        = "sg_bastion-external"
  network_id  = yandex_vpc_network.fsd-network.id
  description = "Группа безопасности для внешнего доступа"
}

#--------- postgres ------------------
resource "yandex_vpc_security_group" "sg-postgres" {
  name       = "sg-postgres"
  network_id = yandex_vpc_network.fsd-network.id
}

#--------- WEB ------------------
resource "yandex_vpc_security_group" "sg-webservers" {
  name        = "sg-webservers"
  description = "Webservers security group"
  network_id  = yandex_vpc_network.fsd-network.id
}

#-------------- prometheus + grafana ----------------
resource "yandex_vpc_security_group" "sg-prometheus" {
  name        = "sg-prometheus"
  description = "prometheus security groups"
  network_id  = yandex_vpc_network.fsd-network.id
}

resource "yandex_vpc_security_group" "sg-grafana" {
  name        = "sg-grafana"
  description = "grafana security groups"
  network_id  = yandex_vpc_network.fsd-network.id
}

#--------- kibana ------------------
resource "yandex_vpc_security_group" "sg-kibana" {
  name        = "sg-kibana"
  description = "kibana security group"
  network_id  = yandex_vpc_network.fsd-network.id
}

#--------- elastic ------------------
resource "yandex_vpc_security_group" "sg-elastic" {
  name        = "sg-elastic"
  description = "elastic security group"
  network_id  = yandex_vpc_network.fsd-network.id
}

#--------- LOAD BALANCER ------------------
resource "yandex_vpc_security_group" "sg-load_balancer" {
  name        = "sg-load-balancer"
  description = "Load balancer security group"
  network_id  = yandex_vpc_network.fsd-network.id
}
