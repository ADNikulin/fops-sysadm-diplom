output "external_ip_address_server" {
  value = module.nginx-server-1.external_ip_address_server
}

output "internal_ip_address_server" {
  value = module.nginx-server-1.internal_ip_address_server
}

output "server_id" {
  value = module.nginx-server-1.server_id
}

output "server_name" {
  value = module.nginx-server-1.server_name
}

output "server_status" {
  value = module.nginx-server-1.server_status
}

output "network_id" {
  value = module.fsd-networks.network_id
}

output "network_name" {
  value = module.fsd-networks.network_name
}

output "subnet_id" {
  value = module.fsd-networks.subnet_id
}


output "subnet_name" {
  value = module.fsd-networks.subnet_name
}