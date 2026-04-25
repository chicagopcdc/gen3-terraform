resource "aws_secretsmanager_secret" "gearbox_g3auto" {
  name = "${var.vpc_name}-default-gearbox-g3auto"
}

resource "aws_secretsmanager_secret_version" "gearbox_g3auto" {
  secret_id     = aws_secretsmanager_secret.gearbox_g3auto.id
  secret_string = var.gearbox_g3auto_config_path != "" ? file(var.gearbox_g3auto_config_path) : templatefile("${path.module}/templates/gearbox-g3auto.tftpl", {
    hostname              = var.hostname
    gearbox_g3auto_access_key = var.gearbox_g3auto_access_key
    gearbox_g3auto_secret_access_key = var.gearbox_g3auto_secret_key
    region                  = var.region
    testing                 = var.gearbox_g3auto_testing
    debug                   = var.gearbox_g3auto_debug
    enabled_phi             = var.gearbox_g3auto_enabled_phi
    dummy_s3                = var.gearbox_g3auto_dummy_s3
    allowed_issuers         = join(",", tolist(var.gearbox_g3auto_allowed_issuers))
    user_api                = var.gearbox_g3auto_user_api
    force_issuer            = var.gearbox_g3auto_force_issuer
    gearbox_middleware_path = var.gearbox_middleware_path
    s3_prod_bucket_name     = var.s3_prod_bucket_name
    prod_promotion_role_arn = var.prod_promotion_role_arn
  })
}
