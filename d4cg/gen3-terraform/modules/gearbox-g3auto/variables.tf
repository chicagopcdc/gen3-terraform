variable "gearbox_g3auto_access_key" {
  default = ""
}

variable "gearbox_g3auto_secret_key" {
  default = ""
}

variable "data_release_bucket" {
  default = ""
}

variable "hostname" {
  description = "hostname of the commons"
  default = ""
}

variable "gearbox_g3auto_config_path" {
  default = ""
}

variable "vpc_name" {
  default = "Commons1"
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

variable "prod_promotion_role_arn" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

