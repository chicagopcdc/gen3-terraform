output "bot_secret" {
  value     = aws_iam_access_key.bot_user_key.secret
  sensitive = true
}

output "bot_id" {
  value = aws_iam_access_key.bot_user_key.id
}

output "prod_promotion_role_arn" {
  value = "${var.is_gearbox_prod ? join("", aws_iam_role.staging_promotion_role.*.arn) : ""}"
  description = "ARN of the staging promotion role, empty if not created"
}
