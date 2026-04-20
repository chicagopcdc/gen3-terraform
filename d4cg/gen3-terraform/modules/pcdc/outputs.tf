output "amanuensis-bot_user_id" {
  value = one(module.amanuensis-bot-user[*].bot_id)
}

output "amanuensis-bot_user_secret" {
  value     = one(module.amanuensis-bot-user[*].bot_secret)
  sensitive = true
}

output "data-release-bucket_name" {
  value = one(module.amanuensis-data-release-bucket[*].bucket_name)
}
