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

variable "internal_ips_bastion" {
  type = string
}

variable "internal_ips_zone_a" {
  type = string
}

variable "internal_ips_zone_b" {
  type = string
}

variable "service_account_id" {
  type        = string
  description = "service_account_id"
}

variable "external_ip_bastion" {
  type        = string
  description = "service_account_id"
}

variable "preemptible" {
  type        = bool
  description = "preemptible VM"
  default     = false
}
