# Список переменных для модуля, которые необходимо передать для корректной его работы
variable "zone" {
  description = "network-zone, ru-central1-a or ru-central1-b or ru-central1-c"
  default     = "ru-central1-b"
  type        = string
}

variable "network-name" {
  description = "Network name"
  type        = string
}
