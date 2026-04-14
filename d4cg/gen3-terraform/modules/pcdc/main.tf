module "amanuensis-data-release-bucket" {
  source   = "../amanuensis-data-release-bucket"
  vpc_name = var.vpc_name
}

module "amanuensis-bot-user" {
  source             = "../bot-user"
  vpc_name           = var.vpc_name
  bot_name           = "amanuensis"
  bucket_name        = module.amanuensis-data-release-bucket.bucket_name
  bucket_access_arns = var.amanuensis-bot_bucket_access_arns
}

module "amanuensis-config" {
  source                 = "../amanuensis-config"
  vpc_name               = var.vpc_name
  amanuensis_access_key  = module.amanuensis-bot-user.bot_id
  amanuensis_secret_key  = module.amanuensis-bot-user.bot_secret
  data_release_bucket    = module.amanuensis-data-release-bucket.bucket_name
  hostname               = var.hostname
  amanuensis_config_path = var.amanuensis_config_path
}
