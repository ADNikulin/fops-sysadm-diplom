# Список переменных для данного окружения
variable "zone" {
  description = "network-zone, ru-central1-a or ru-central1-b or ru-central1-c"
  default     = "ru-central1-b"
  type        = string
}

variable "location-zone_ru-central1-b" {
  description = "network-zone ru-central1-b"
  default     = "ru-central1-b"
  type        = string
}

variable "location-zone_ru-central1-a" {
  description = "network-zone ru-central1-a"
  default     = "ru-central1-a"
  type        = string
}

variable "network-name" {
  description = "Network name"
  type        = string
}

variable "subnet-a-name" {
  description = "Subnet-a name"
  type        = string
}

variable "subnet-b-name" {
  description = "Subnet-b name"
  type        = string
}

variable "v4_cidr_blocks-a" {
  description = "pool of ipv4 addresses, e.g "
  type        = string
}

variable "v4_cidr_blocks-b" {
  description = "pool of ipv4 addresses, e.g "
  type        = string
}

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}