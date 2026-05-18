variable "vpc_name" {
  description = "Name of the VPC, used to derive the bucket name"
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent object versions are deleted"
  default     = 180
}

variable "allowed_origins" {
  description = "List of allowed CORS origins (full URLs) for the bucket. CORS is disabled when empty."
  type        = list(string)
  default     = []
}

variable "manage_lifecycle" {
  description = "Set to false to disable the lifecycle configuration so it can be managed by the calling module"
  type        = bool
  default     = true
}

variable "bucket_suffix" {
  description = "Suffix to append to the bucket name, allowing for multiple buckets to be created with the same VPC name"
  default     = ""
  type        = string
}