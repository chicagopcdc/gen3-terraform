variable "bucket_name" {}

variable "environment" {}

variable "cloud_trail_count" {
  # this variable is used to conditionally create a cloud trail
  # Using this module to create another bucket in the same "environment" with nonzero
  # count for this variable will result in an error because aspects of the cloud trail
  # will already exist
  default = "1"
  description = "Number of cloud trails to create - Limited to 5 trails per region"
}

variable "manage_lifecycle" {
  description = "Set to false to disable the lifecycle configuration so it can be managed by the calling module"
  type        = bool
  default     = true
}

locals {
  clean_bucket_name = replace(replace(var.bucket_name, "_", "-"),".", "-")
}
