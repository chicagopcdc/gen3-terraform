resource "aws_secretsmanager_secret" "gearbox_g3auto" {
  name = "${var.vpc_name}-default-gearbox-g3auto"
}

resource "aws_secretsmanager_secret_version" "gearbox_g3auto" {
  secret_id     = aws_secretsmanager_secret.gearbox_g3auto.id
  secret_string = var.gearbox_g3auto_config_path != "" ? file(var.gearbox_g3auto_config_path) : templatefile("${path.module}/templates/gearbox-g3auto.tftpl", {
    gearbox_g3auto_access_key = var.gearbox_g3auto_access_key
    gearbox_g3auto_secret_access_key = var.gearbox_g3auto_secret_key
    prod_promotion_role_arn = var.prod_promotion_role_arn
  })
}
