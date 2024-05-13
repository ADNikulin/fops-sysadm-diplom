# Список переменных для данного окружения
variable "zone" {
  description = "network-zone, ru-central1-a or ru-central1-b or ru-central1-c"
  default     = "ru-central1-b"
  type        = string
}

variable "network-name" {
  description = "Network name"
  type        = string
}

variable "subnet-name" {
  description = "Subnet name"
  type        = string
}

variable "v4_cidr_blocks" {
  description = "pool of ipv4 addresses, e.g "
  type        = string
}

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}