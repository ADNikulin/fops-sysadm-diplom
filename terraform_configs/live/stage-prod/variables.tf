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

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}

variable "internal_ip_blocks-a" {
  type = string
}

variable "internal_ip_blocks-b" {
  type = string
}