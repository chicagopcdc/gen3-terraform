module "amanuensis-data-release-bucket" {
  count    = var.amanuensis_enabled ? 1 : 0
  source   = "../d4cg-bucket"
  bucket_suffix = "data-release"
  vpc_name = var.vpc_name
  manage_lifecycle  = true
}

module "amanuensis-bot-user" {
  count              = var.amanuensis_enabled ? 1 : 0
  source             = "../bot-user"
  vpc_name           = var.vpc_name
  bot_name           = "amanuensis"
  bucket_name        = module.amanuensis-data-release-bucket[0].bucket_name
  bucket_access_arns = var.amanuensis-bot_bucket_access_arns
}

module "amanuensis-config" {
  count                  = var.amanuensis_enabled ? 1 : 0
  source                 = "../amanuensis-config"
  vpc_name               = var.vpc_name
  amanuensis_access_key  = module.amanuensis-bot-user[0].bot_id
  amanuensis_secret_key  = module.amanuensis-bot-user[0].bot_secret
  data_release_bucket    = module.amanuensis-data-release-bucket[0].bucket_name
  hostname               = var.hostname
  amanuensis_config_path = var.amanuensis_config_path
}

module "amanuensis-db" {
  count                   = var.amanuensis_enabled ? 1 : 0
  source                  = "../../../../tf_files/aws/aurora_db"
  vpc_name                = var.vpc_name
  service                 = "amanuensis"
  admin_database_username = var.aurora_username
  admin_database_password = var.aurora_password
  namespace               = var.namespace
  create_db               = var.create_dbs
  secrets_manager_enabled = true
}
