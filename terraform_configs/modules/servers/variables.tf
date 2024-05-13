# Список переменных для модуля, которые необходимо передать для корректной его работы
variable "zone" {
  description = "network-zone, ru-central1-a or ru-central1-b or ru-central1-c"
  default     = "ru-central1-b"
  type        = string
}

variable "server-app-name" {
  description = "Name VM in controll web"
  type        = string
}

variable "server-host-name" {
  description = "VM machine name"
  type        = string
}

variable "core_fraction" {
  description = "Доля процессорного времени"
  type        = number
  default     = 20
}

variable "servers_subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}