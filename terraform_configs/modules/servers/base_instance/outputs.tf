# Список выходных значений модуля
output "internal_ip_address_server" {
  value = yandex_compute_instance.instance.network_interface.0.ip_address
}

# output "external_ip_address_server" {
#   value = yandex_compute_instance.server.network_interface.0.nat_ip_address
# }

output "server_id" {
  value = yandex_compute_instance.instance.id
}

output "server_subnet_id" {
  value = var.servers_subnet_id
}

output "server_name" {
  value = yandex_compute_instance.instance.name
}

output "server_status" {
  value = yandex_compute_instance.instance.status
}
