
variable "gearbox-bot_bucket_access_arns" {
  description = "When gearbox bot has to access another bucket that wasn't created by the VPC module"
  default     = []
}

variable "vpc_name" {
  default = "Commons1"
}

variable "gearbox_config_path" {
  default = ""
}

variable "namespace" {
  default = "default"
}

variable "gearbox_enabled" {
  description = "Enable gearbox"
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

variable "prod_promotion_role_arn" {
  default     = ""
  description = "Role ARN in PROD that staging can assume. Null in prod."
}

variable "staging_account_id" {
  default     = ""
  description = "Role ARN in PROD that staging can assume. Null in prod."
}

variable "is_gearbox_staging" {
  default = false
}

variable "is_gearbox_prod" {
  default = false
}

variable "gearbox_g3auto_config_path" {
  default = ""
}








