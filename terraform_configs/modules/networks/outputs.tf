# Список выходных значений модуля
output "network_name" {
    value = yandex_vpc_network.network-main.name
}

output "subnet_name" {
    value = yandex_vpc_subnet.subnet-a.name
}

output "subnet_id" {
    value = yandex_vpc_subnet.subnet-a.id
}

output "network_id" {
    value = yandex_vpc_network.network-main.id
}