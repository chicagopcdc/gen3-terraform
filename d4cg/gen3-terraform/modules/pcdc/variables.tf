
variable "amanuensis-bot_bucket_access_arns" {
  description = "When amanuensis bot has to access another bucket that wasn't created by the VPC module"
  default     = []
}

variable "vpc_name" {
  default = "Commons1"
}

variable "amanuensis_config_path" {
  default = ""
}

variable "hostname" {
  description = "hostname of the commons"
  default = ""
}








