
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

variable "hostname" {
  description = "hostname of the commons"
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

variable "gearbox_g3auto_testing" {
  default = false
}

variable "gearbox_g3auto_debug" {
  default = false
}


variable "gearbox_g3auto_enabled_phi" {
  default = false
}

variable "gearbox_g3auto_dummy_s3" {
  default = false
}

variable "gearbox_g3auto_allowed_issuers" {
  type    = list(string)
  default = []
}

variable "gearbox_g3auto_user_api" {
  default = "http://fence-service/"
}

variable "gearbox_g3auto_force_issuer" {
  default = true
}

variable "gearbox_middleware_path" {
  default = "/gearbox/src/gearbox/keys/jwt_public_key.pem"
}

variable "s3_prod_bucket_name" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}








