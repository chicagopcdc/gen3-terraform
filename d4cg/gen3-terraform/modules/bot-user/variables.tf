variable "vpc_name" {}

variable "bucket_name" {}

variable "bot_name" {}

variable "bucket_access_arns" {
  description = "When the user / service bot has to access another bucket that wasn't created by the VPC module"
  default     = []
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
