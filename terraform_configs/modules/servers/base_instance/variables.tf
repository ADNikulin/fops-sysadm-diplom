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

variable "server-app-description" {
  description = "Name VM in controll web"
  type        = string
  default     = ""
}

variable "server-os_family" {
  description = "Name VM in controll web"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "server-host-name" {
  description = "VM machine name"
  type        = string
}

variable "server-zone-location" {
  description = "VM machine location"
  type        = string
}

variable "server-core_fraction" {
  description = "Доля процессорного времени"
  type        = number
  default     = 20
}

variable "server-core_numbers" {
  description = "Доля процессорного времени"
  type        = number
  default     = 2
}

variable "server-memory" {
  description = "Доля процессорного времени"
  type        = number
  default     = 2
}

variable "servers_subnet_id" {
  description = "servers_subnet_id"
  type        = string
}

variable "ipv4_internal" {
  description = "ipv4_internal"
  type        = string
  nullable    = true
}

variable "sg_group_ids" {
  description = "servers_security_internal_group_id"
  type        = list(string)
}

variable "server-disk_type" {
  description = "network-hdd or network-ssd"
  type = string
  default = "network-hdd"
}

variable "server-disk_memory" {
  description = "server-disk_memory"
  type = number
  default = 10
}

variable "preemptible" {
  default = true
  description = "preemptible"
  type = bool
}

variable "nat" {
  default = false
  description = "using public IP"
  type = bool
}

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}

variable "service_account_id" {
  type = string
  description = "service_account_id"
}