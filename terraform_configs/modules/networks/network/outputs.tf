# Список выходных значений модуля
output "network_name" {
    value = yandex_vpc_network.network-main.name
}

output "network_id" {
    value = yandex_vpc_network.network-main.id
}