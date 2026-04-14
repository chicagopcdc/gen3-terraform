output "amanuensis-bot_user_id" {
  value = module.amanuensis-bot-user.bot_id
}

output "amanuensis-bot_user_secret" {
  value     = module.amanuensis-bot-user.bot_secret
  sensitive = true
}

output "data-release-bucket_name" {
  value = module.amanuensis-data-release-bucket.bucket_name
}
