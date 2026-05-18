
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

variable "namespace" {
  default = "default"
}

variable "amanuensis_enabled" {
  description = "Enable amanuensis"
  type        = bool
  default     = true
}

variable "create_dbs" {
  description = "Whether to create databases or not. Requires connectivity to RDS cluster."
  default = false
}

variable "aurora_username" {
  description = "aurora username"
  default = ""
}

variable "aurora_password" {
  description = "aurora password"
  default = ""
}







