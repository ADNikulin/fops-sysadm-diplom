# Список выходных значений модуля
output "subnet_name" {
    value = yandex_vpc_subnet.subnet.name
}

output "subnet_id" {
    value = yandex_vpc_subnet.subnet.id
}
