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

variable "location-zone_ru-central1-d" {
  description = "network-zone ru-central1-d"
  default     = "ru-central1-d"
  type        = string
}

variable "path_to_metadata_user_ssh" {
  description = "Path to Users Metadata access by ssh"
  type        = string
}

variable "service_account_id" {
  type        = string
  description = "service_account_id"
}

variable "preemptible" {
  type        = bool
  description = "preemptible VM"
  default     = false
}

variable "ansible_workdir" {
  type        = string
  description = "ansible_workdir"
}

variable "kibana_password" {
  type        = string
  description = "kibana_password"
}

variable "telegram_bot_token" {
  type        = string
  description = "telegram_bot_token"
}

variable "telegram_chat_id" {
  type        = string
  description = "telegram_chat_id"
}

variable "pg_admin_password" {
  type = string
  description = "pg_admin_password"
}

variable "nat_for_private" {
  type = bool
  description = "nat for private hosts by configure "
  default = false
}