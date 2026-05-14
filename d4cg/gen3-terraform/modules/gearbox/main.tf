module "gearbox-match-conditions-bucket" {
  count    = var.gearbox_enabled ? 1 : 0
  source   = "../d4cg-bucket"
  vpc_name = var.vpc_name
  bucket_suffix = "gearbox-match-conditions"
  manage_lifecycle  = false
}

module "gearbox-bot-user" {
  count              = var.gearbox_enabled ? 1 : 0
  source             = "../bot-user"
  vpc_name           = var.vpc_name
  bot_name           = "gearbox"
  bucket_name        = module.gearbox-match-conditions-bucket[0].bucket_name
  bucket_access_arns = var.gearbox-bot_bucket_access_arns
  prod_promotion_role_arn = var.prod_promotion_role_arn
  staging_account_id    = var.staging_account_id
  is_gearbox_staging    = var.is_gearbox_staging
  is_gearbox_prod       = var.is_gearbox_prod
}

module "gearbox-db" {
  count                   = var.gearbox_enabled ? 1 : 0
  source                  = "../../../../tf_files/aws/aurora_db"
  vpc_name                = var.vpc_name
  service                 = "gearbox"
  admin_database_username = var.aurora_username
  admin_database_password = var.aurora_password
  namespace               = var.namespace
  create_db               = var.create_dbs
  secrets_manager_enabled = true
}

module "gearbox-g3auto" {
  count = var.gearbox_enabled ? 1 : 0
  source = "../gearbox-g3auto"
  vpc_name = var.vpc_name
  gearbox_g3auto_access_key = module.gearbox-bot-user[0].bot_id
  gearbox_g3auto_secret_key = module.gearbox-bot-user[0].bot_secret
  prod_promotion_role_arn = var.prod_promotion_role_arn
}

module "gearbox-middleware-bot-user" {
  count                   = var.gearbox_enabled ? 1 : 0
  source                  = "../bot-user"
  vpc_name                = var.vpc_name
  bot_name                = "gearbox-middleware"
  bucket_name             = module.gearbox-match-conditions-bucket[0].bucket_name
  bot_object_actions      = ["s3:GetObject"]
}

module "gearbox-middleware-g3auto" {
  count = var.gearbox_enabled ? 1 : 0
  source = "../gearbox-middleware-g3auto"
  vpc_name = var.vpc_name
  gearbox_middleware_g3auto_access_key = module.gearbox-middleware-bot-user[0].bot_id
  gearbox_middleware_g3auto_secret_key = module.gearbox-middleware-bot-user[0].bot_secret
}