output "gearbox-bot_user_id" {
  value = one(module.gearbox-bot-user[*].bot_id)
}

output "gearbox-bot_user_secret" {
  value     = one(module.gearbox-bot-user[*].bot_secret)
  sensitive = true
}

output "data-release-bucket_name" {
  value = one(module.gearbox-match-conditions-bucket[*].bucket_name)
}
