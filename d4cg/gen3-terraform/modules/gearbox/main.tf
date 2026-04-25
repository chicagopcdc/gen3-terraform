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
  hostname = var.hostname
  gearbox_g3auto_access_key = module.gearbox-bot-user[0].bot_id
  gearbox_g3auto_secret_key = module.gearbox-bot-user[0].bot_secret
  data_release_bucket = module.gearbox-match-conditions-bucket[0].bucket_name
  gearbox_g3auto_config_path = var.gearbox_g3auto_config_path
  prod_promotion_role_arn = var.prod_promotion_role_arn
  s3_prod_bucket_name = var.s3_prod_bucket_name
  gearbox_g3auto_allowed_issuers = var.gearbox_g3auto_allowed_issuers
  gearbox_g3auto_user_api = var.gearbox_g3auto_user_api
  gearbox_g3auto_force_issuer = var.gearbox_g3auto_force_issuer
  gearbox_g3auto_testing = var.gearbox_g3auto_testing
  gearbox_g3auto_debug = var.gearbox_g3auto_debug
  gearbox_g3auto_enabled_phi = var.gearbox_g3auto_enabled_phi
  gearbox_g3auto_dummy_s3 = var.gearbox_g3auto_dummy_s3
  gearbox_middleware_path = var.gearbox_middleware_path
  region = var.region
}